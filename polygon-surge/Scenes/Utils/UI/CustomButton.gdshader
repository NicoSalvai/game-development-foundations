shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 32.0) = 1.0;
uniform bool hovering = false;
uniform float idle_pixel_min : hint_range(1.0, 4.0) = 1.0;
uniform float idle_pixel_max : hint_range(1.0, 4.0) = 1.5;
uniform float idle_speed : hint_range(0.5, 10.0) = 3.0;

void fragment() {
	float effective_size = pixel_size;

	if (hovering && pixel_size <= 1.0) {
		float t = (sin(TIME * idle_speed) + 1.0) / 2.0;
		effective_size = mix(idle_pixel_min, idle_pixel_max, t);
	}

	vec4 modulated = COLOR;  // guarda el modulate que Godot ya aplicó

	if (effective_size <= 1.0) {
		COLOR = texture(TEXTURE, UV) * modulated;
	} else {
		vec2 texture_size = vec2(textureSize(TEXTURE, 0));
		vec2 block_uv = floor(UV * texture_size / effective_size) * effective_size / texture_size;
		COLOR = texture(TEXTURE, block_uv) * modulated;
	}
}