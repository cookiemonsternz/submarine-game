shader_type spatial;
render_mode unshaded;

void vertex() {
	// Called for every vertex the materia is visible on.
}

void fragment() {
	ALBEDO = vec3(1.0, 0.5, 0.75);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
