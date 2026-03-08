shader_type canvas_item;

uniform float percentage = 0.0;

const float wave_density = 10.0;
const float wave_amplitude = 0.01;
const int num_waves = 4;
const float amp_decay = 0.5;
const float freq_decay = 2.0;
uniform float wave_speed = 2.0;

void fragment() {
	float wave = 0.0;
	float density = wave_density;
	float amplitude = wave_amplitude;

	for (int i = 0; i < num_waves; i++) {
		wave += amplitude * sin(UV.y * density + TIME * wave_speed);
		density *= freq_decay;
		amplitude *= amp_decay;
	}

	float water_height = 1.0 - percentage;
	float surface = water_height + wave;

	if (UV.x < surface) {
		COLOR = vec4(0.0);
	}
}