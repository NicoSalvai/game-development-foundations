shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 64.0) = 1.0;
uniform float alpha : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
	vec2 screen_uv = SCREEN_UV;

	if (pixel_size > 1.0) {
		vec2 screen_size = vec2(textureSize(screen_texture, 0));
		screen_uv = floor(SCREEN_UV * screen_size / pixel_size) * pixel_size / screen_size;
	}

	vec3 screen_col = texture(screen_texture, screen_uv).rgb;
	vec3 final_col = mix(screen_col, vec3(0.0), alpha);
	COLOR = vec4(final_col, 1.0);
}