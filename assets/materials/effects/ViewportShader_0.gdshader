shader_type canvas_item;
uniform bool hallucinating = false;
void fragment() {
	vec2 uv = UV;
	if (hallucinating) {
		uv += vec2(sin(uv.y * 24.0 + TIME * 3.0), cos(uv.x * 24.0 + TIME * 3.0)) * 0.004;
	}
	vec4 c = texture(TEXTURE, uv);
	if (hallucinating) {
		c.rgb = mix(c.rgb, c.gbr, 0.35 + 0.15 * sin(TIME * 2.0));
	}
	COLOR = c;
}
