shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.004, 0.008, 0.012, 1.0);
uniform float noise_strength : hint_range(0.0, 0.1) = 0.025;
uniform float noise_scale : hint_range(10.0, 200.0) = 90.0;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(
        mix(hash(i), hash(i + vec2(1,0)), f.x),
        mix(hash(i + vec2(0,1)), hash(i + vec2(1,1)), f.x),
        f.y
    );
}

void fragment() {
    float n = noise(UV * noise_scale) * noise_strength;
    vec3 col = base_color.rgb + n;
    COLOR = vec4(col, 1.0);
}