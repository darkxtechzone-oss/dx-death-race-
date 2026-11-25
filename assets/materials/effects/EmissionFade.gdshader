shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;
uniform vec4 albedo : hint_color = vec4(1.0);
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular = 0.5;
uniform float metallic = 0.0;
uniform float roughness = 1.0;
uniform float point_size = 1.0;
uniform vec4 emission : hint_color = vec4(1.0);
uniform float emission_energy = 1.0;
uniform vec3 uv1_scale = vec3(1.0);
uniform vec3 uv1_offset = vec3(0.0);
uniform vec3 uv2_scale = vec3(1.0);
uniform vec3 uv2_offset = vec3(0.0);
uniform bool billboard = false;
uniform bool apply_scale = false;
uniform float e_fade = 1.0;
uniform float time = 0.0;
varying float v_life;
void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
	v_life = COLOR.a;
	if (billboard) {
		MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0], CAMERA_MATRIX[1], CAMERA_MATRIX[2], WORLD_MATRIX[3]);
		if (apply_scale) {
			MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(WORLD_MATRIX[0].xyz), 0.0, 0.0, 0.0), vec4(0.0, length(WORLD_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(WORLD_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));
		}
	}
}
void fragment() {
	vec4 t = texture(texture_albedo, UV);
	ALBEDO = albedo.rgb * t.rgb * COLOR.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	ALPHA = albedo.a * t.a * COLOR.a;
	EMISSION = emission.rgb * emission_energy * exp(-e_fade * (1.0 - COLOR.a));
}
