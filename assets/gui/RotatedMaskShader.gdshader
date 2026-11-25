shader_type canvas_item;
// DarkX placeholder: reveals the fill texture through a rotating mask.
uniform sampler2D mask;
uniform float rotation = 0.0;
void fragment() {
	vec2 uv = UV - vec2(0.5);
	float c = cos(rotation);
	float s = sin(rotation);
	vec2 ruv = vec2(c * uv.x - s * uv.y, s * uv.x + c * uv.y) + vec2(0.5);
	vec4 col = texture(TEXTURE, UV);
	col.a *= texture(mask, ruv).a;
	COLOR = col;
}
