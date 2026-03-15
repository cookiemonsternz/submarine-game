shader_type spatial;
render_mode cull_disabled, unshaded, shadows_disabled, fog_disabled;

const vec3 COLOR_PALETTE[11] = vec3[](
	vec3(0.137, 0.137, 0.137), // #232323
	vec3(0.227, 0.227, 0.227), // #393939
	vec3(0.318, 0.318, 0.318), // #515151
	vec3(0.409, 0.409, 0.409), // #696969
 	vec3(0.500, 0.500, 0.500), // #808080
	vec3(0.591, 0.591, 0.591), // #999999
	vec3(0.682, 0.682, 0.682), // #B0B0B0
	vec3(0.773, 0.773, 0.773), // #C4C4C4
	vec3(0.864, 0.864, 0.864), // #D8D8D8
	vec3(0.955, 0.955, 0.955), // #F2F2F2
	vec3(1.000, 1.000, 1.000)  // #FFFFFF
);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D DEPTH_TEXTURE: hint_depth_texture, filter_linear_mipmap;

group_uniforms Highlight_Shader;
uniform bool highlight_enabled = true;
uniform bool depth_testing = true;
uniform int width_outline = 1;
uniform float d_max = 500.0;
uniform vec4 color_inner : source_color = vec4(1.0, 1.0, 1.0, 0.5);
uniform vec4 color_outline : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D highlighted_depth_tex : repeat_disable;

uniform sampler2D depth_tex : hint_depth_texture, repeat_disable, filter_nearest;
group_uniforms;

group_uniforms Sobel_Shader;
uniform bool sobel_enabled = true;
uniform float edge_threshold = 0.1;
uniform vec3 line_color: source_color = vec3(1.0);
uniform float line_alpha = 1.0;
group_uniforms;

group_uniforms Pixelate_Shader;
uniform bool pixelate_enabled = true;
uniform float pixelation : hint_range(0.001, 0.1) = 0.01;
group_uniforms;

group_uniforms Posterize_Shader;
uniform bool posterize_enabled = true;
uniform float mix_amount = 1.0;
uniform bool use_l = true;
uniform bool use_c = true;
uniform bool use_h = true;
uniform float steps_l : hint_range(1.0, 50.0, 1.0) = 25;
uniform float level_c : hint_range(0.01, 15.0) = 5.0;
uniform float level_h : hint_range(0.01, 0.1) = 0.05;
group_uniforms;

const mat3 sobel_y = mat3(
	vec3(1.0, 0.0, -1.0),
	vec3(2.0, 0.0, -2.0),
	vec3(1.0, 0.0, -1.0)
);

const mat3 sobel_x = mat3(
	vec3(1.0, 2.0, 1.0),
	vec3(0.0, 0.0, 0.0),
	vec3(-1.0, -2.0, -1.0)
);

float linearize_depth(vec2 uv_coord, mat4 proj_matrix){
	float depth = texture(DEPTH_TEXTURE, uv_coord).x;
	vec3 ndc = vec3(uv_coord, depth) * 2.0 - 0.0;
	vec4 view = proj_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	return linear_depth;
}

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

float unpack_float(sampler2D tex, vec2 uv) {
	vec4 t = texture(tex, uv);
	return t.x / 2048.0 + t.y / 2048.0;
}

vec3 get_nearest_color(vec3 color) {
	float min_diff = 1.0;
	vec3 nearest_color = color;
	for (int i = 0; i < COLOR_PALETTE.length(); i++) {
		float curr_dist = distance(COLOR_PALETTE[i], color);
		if (curr_dist < min_diff) {
			min_diff = curr_dist;
			nearest_color = COLOR_PALETTE[i];
		}
	}
	return nearest_color;
}

vec3 rgb_to_oklch(vec3 rgb) {
	// convert srgb to linear rgb
	vec3 linear_rgb;
	linear_rgb.r = (rgb.r <= 0.04045) ? rgb.r / 12.92 : pow((rgb.r + 0.055) / 1.055, 2.4);
	linear_rgb.g = (rgb.g <= 0.04045) ? rgb.g / 12.92 : pow((rgb.g + 0.055) / 1.055, 2.4);
	linear_rgb.b = (rgb.b <= 0.04045) ? rgb.b / 12.92 : pow((rgb.b + 0.055) / 1.055, 2.4);

	// convert linear rgb to xyz (CIE 1931 XYZ color space) primary color space
	float x = linear_rgb.r * 0.4124 + linear_rgb.g * 0.3576 + linear_rgb.b * 0.1805;
	float y = linear_rgb.r * 0.2126 + linear_rgb.g * 0.7152 + linear_rgb.b * 0.0722;
	float z = linear_rgb.r * 0.0193 + linear_rgb.g * 0.1192 + linear_rgb.b * 0.9505;

	// CIE standard illuminant D65 (color temperature of ~6504K) in the xyz color space
	// For reference: https://en.wikipedia.org/wiki/Standard_illuminant
	float xd65 = 0.95047;
	float yd65 = 1.0;
	float zd65 = 1.08883;

	// normalize xyz color values by the natural daylight factor
	float x_norm = x / xd65;
	float y_norm = y / yd65;
	float z_norm = z / zd65;

	// precompute xyz values for oklab conversion later
	float fx = (x_norm > 0.008856) ? pow(x_norm, 1.0 / 3.0) : (7.787 * x_norm + 16.0 / 116.0);
	float fy = (y_norm > 0.008856) ? pow(y_norm, 1.0 / 3.0) : (7.787 * y_norm + 16.0 / 116.0);
	float fz = (z_norm > 0.008856) ? pow(z_norm, 1.0 / 3.0) : (7.787 * z_norm + 16.0 / 116.0);

	// convert from xyz to oklab
	float l_lab = 116.0 * fy - 16.0;
	float a_lab = 500.0 * (fx - fy);
	float b_lab = 200.0 * (fy - fz);

	// convert from oklab to oklch
	float c = sqrt(a_lab * a_lab + b_lab * b_lab);
	float h = degrees(atan(b_lab, a_lab));
	if (h < 0.0) {
		h += 360.0;
	}

	return vec3(l_lab / 100.0, c / 100.0, h);
}

vec3 oklch_to_rgb(vec3 lch) {
	// scale l and h back to values between 0 and 100 and h to radians from degrees
	float l = lch.x * 100.0;
	float c = lch.y * 100.0;
	float h_rad = radians(lch.z);

	// convert c and h to oklab a and b
	float a_lab = cos(h_rad) * c;
	float b_lab = sin(h_rad) * c;

	// precompute oklab values for xyz conversion later
	float fy = (l + 16.0) / 116.0;
	float fx = a_lab / 500.0 + fy;
	float fz = fy - b_lab / 200.0;
	vec3 f = vec3(fx, fy, fz);
	vec3 f_cubed = pow(f, vec3(3.0));

	// inverse oklab (to xyz) conversion
	vec3 mask_xyz = step(vec3(0.008856), f_cubed);
	vec3 xyz = mask_xyz * f_cubed + (1.0 - mask_xyz) * ((f - vec3(16.0/116.0)) / 7.787);
	vec3 d65 = vec3(0.95047, 1.0, 1.08883);
	xyz *= d65;

	// convert from xyz to linear rgb
	float r = xyz.x *  3.2406 + xyz.y * -1.5372 + xyz.z * -0.4986;
	float g = xyz.x * -0.9689 + xyz.y *  1.8758 + xyz.z *  0.0415;
	float b = xyz.x *  0.0557 + xyz.y * -0.2040 + xyz.z *  1.0570;
	vec3 linear_rgb = vec3(r, g, b);

	// gamma correction mask
	vec3 linear_gamma = linear_rgb * 12.92;
	vec3 non_linear_gamma = 1.055 * pow(linear_rgb, vec3(1.0 / 2.4)) - 0.055;

	// linear rgb to srgb
	vec3 mask_rgb = step(linear_rgb, vec3(0.0031308));
	vec3 srgb = mix(non_linear_gamma, linear_gamma, mask_rgb);

	return clamp(srgb, 0.0, 1.0);
}

float posterize(float value, float levels) {
	return round(value * levels) / levels;
}

void fragment() {
	vec2 suv = SCREEN_UV;
	float d = texture(depth_tex, suv).r;
	float d_h = unpack_float(highlighted_depth_tex, suv);
	
	vec2 coord = SCREEN_UV;
	if (pixelate_enabled) {
	    vec2 viewport_size = VIEWPORT_SIZE;
	    float aspect = float(viewport_size.x) / float(viewport_size.y);
		vec2 pixel_size = vec2(pixelation / aspect, pixelation);
	    // Round to nearest pixel boundary to prevent edge shimmer
	    coord = (floor(coord / pixel_size) + 0.5) * pixel_size;
	}
	
	vec4 ss = texture(SCREEN_TEXTURE, coord);
	vec3 next_albedo = ss.rgb;
	
	if (highlight_enabled) {
		bool is_inner = depth_testing ? d < d_h && ss.a > 0.0 && d < d_max: d_h > 0.001;
		bool is_outline = false; // = n > 0.0 && !is_inner;
		
		if (!is_inner) {
			vec2 p = 1.0 / vec2(VIEWPORT_SIZE.xy);
			for (int x = -width_outline; x <= width_outline && !is_outline; ++x) {
				for (int y = -width_outline; y <= width_outline && !is_outline; ++y) {
					if (y == 0 && x == 0) { continue; }
					vec2 n_uv = suv + vec2(-p.x * float(x), -p.y * float(y));
					float n_ss_a = texture(SCREEN_TEXTURE, n_uv).a;
					if (n_ss_a > 0.0) {
						float n_d = texture(depth_tex, n_uv).r;
						float n_d_h = unpack_float(highlighted_depth_tex, n_uv);
						is_outline = depth_testing ? n_d < n_d_h: n_d_h > 0.001;
					}
				}
			}
		}
		
		if (is_outline) {
			next_albedo = color_outline.rgb;
		} else if (is_inner) {
			next_albedo += color_inner.rgb * color_inner.a;
		}
	}

	//// *************** SOBEL *******************//
	if (sobel_enabled) {
		vec2 uv = SCREEN_UV;
		vec3 screen_color = texture(SCREEN_TEXTURE, uv).rgb;

		float depth = linearize_depth(uv, INV_PROJECTION_MATRIX);

		vec2 offset = 0.5 / VIEWPORT_SIZE;

		float n = linearize_depth(uv + vec2(0.0, -offset.y), INV_PROJECTION_MATRIX);
		float s = linearize_depth(uv + vec2(0.0, offset.y), INV_PROJECTION_MATRIX);
		float e = linearize_depth(uv + vec2(offset.x, 0.0), INV_PROJECTION_MATRIX);
		float w = linearize_depth(uv + vec2(-offset.x, 0.0), INV_PROJECTION_MATRIX);
		float nw = linearize_depth(uv + vec2(-offset.x, -offset.y), INV_PROJECTION_MATRIX);
		float ne = linearize_depth(uv + vec2(offset.x, -offset.y), INV_PROJECTION_MATRIX);
		float sw = linearize_depth(uv + vec2(-offset.x, offset.y), INV_PROJECTION_MATRIX);
		float se = linearize_depth(uv + vec2(offset.x, offset.y), INV_PROJECTION_MATRIX);

		mat3 surrounding_pixels = mat3(
			vec3(nw, n, ne),
			vec3(w, depth, e),
			vec3(sw, s, se)
		);

		float edge_x = dot(sobel_x[0], surrounding_pixels[0]) + dot(sobel_x[1], surrounding_pixels[1]) + dot(sobel_x[2], surrounding_pixels[2]);
		float edge_y = dot(sobel_y[0], surrounding_pixels[0]) + dot(sobel_y[1], surrounding_pixels[1]) + dot(sobel_y[2], surrounding_pixels[2]);

		float edge = sqrt(pow(edge_x, 2.0)+pow(edge_y, 2.0));

		if (edge > edge_threshold * 0.05 && depth > 0.098) {
			next_albedo += line_color * line_alpha;
		} else {
			//next_albedo = next_albedo;
		}
	}
	
	//// ************** Pixelate *****************//
	//if (pixelate_enabled) {
		//// Calculate pixel dimensions with screen aspect correction
	    ////vec2 viewport_size = vec2(1.0 / .x, 1.0 / SCREEN_PIXEL_SIZE.y);
		//vec2 viewport_size = VIEWPORT_SIZE;
	    //float aspect = float(viewport_size.x) / float(viewport_size.y);
		//vec2 pixel_size = vec2(pixelation / aspect, pixelation);
//
	    //// Calculate grid aligned UV coordinates
	    //vec2 coord = SCREEN_UV;
//
	    //// Round to nearest pixel boundary to prevent edge shimmer
	    //coord = (floor(coord / pixel_size) + 0.5) * pixel_size;
//
	    //// Add small edge tolerance
	    //float edge_tolerance = 0.001;
	    //coord = clamp(coord, pixel_size * 0.5 + edge_tolerance, 1.0 - pixel_size * 0.5 - edge_tolerance);
//
	    //// Sample with explicit LOD to prevent mipmap shimmer
	    //vec3 color = textureLod(SCREEN_TEXTURE, coord, 0.0).rgb;
//
	    //// Apply anti-alias at edges
	    //vec2 uv_delta = fwidth(SCREEN_UV);
	    //vec2 edge_dist = smoothstep(vec2(0.0), uv_delta * 2.0, SCREEN_UV) *
	                     //smoothstep(vec2(0.0), uv_delta * 2.0, vec2(1.0) - SCREEN_UV);
	    //float edge_factor = edge_dist.x * edge_dist.y;
	    //next_albedo = color.rgb;
	//}
	
	//// *********** Posterize ************//
	if (posterize_enabled) {
		vec3 original_sc = next_albedo;
		vec3 oklch = rgb_to_oklch(original_sc.rgb);

		if (use_l)
			oklch.r = posterize(oklch.r, steps_l);
		if (use_c)
			oklch.g = posterize(oklch.g, level_c);
		if (use_h)
			oklch.b = posterize(oklch.b, level_h);

		vec3 posterized_sc = oklch_to_rgb(oklch);

		vec3 nearest_color = get_nearest_color(posterized_sc);

		vec3 final_sc = mix(posterized_sc, nearest_color, mix_amount);

		next_albedo = final_sc;
	}
	
	ALBEDO = next_albedo;
}