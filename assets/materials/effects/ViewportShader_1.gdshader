shader_type canvas_item;
uniform float aberration = 0.425;
uniform vec2 center = vec2(0.5, 0.5);
uniform float feather = 0.135;
uniform bool hallucinating = false;
uniform float radius = 0.4;
uniform float strength = 0.08;
uniform float width = 0.09;
void fragment() {
	vec2 d = UV - center;
	float dist = length(d);
	float edge = smoothstep(radius, radius + feather, dist);
	vec2 off = d * strength * edge * aberration;
	if (hallucinating) {
		off += d * 0.03 * sin(TIME * 2.0);
	}
	vec4 c;
	c.r = texture(TEXTURE, UV + off).r;
	c.g = texture(TEXTURE, UV).g;
	c.b = texture(TEXTURE, UV - off).b;
	c.a = texture(TEXTURE, UV).a;
	c.rgb *= 1.0 - edge * width * 3.0;
	COLOR = c;
}
