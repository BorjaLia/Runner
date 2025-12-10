shader_type spatial;
render_mode skip_vertex_transform;

global uniform float world_curve;

uniform sampler2D albedo_texture : source_color;
uniform vec4 albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void vertex() {
	vec4 view_pos = MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
	
	float dist = view_pos.z;
	view_pos.y -= dist * dist * world_curve;
	
	VERTEX = view_pos.xyz;
	
	NORMAL = normalize(MODELVIEW_NORMAL_MATRIX * NORMAL);
	TANGENT = normalize(MODELVIEW_NORMAL_MATRIX * TANGENT);
	BINORMAL = normalize(MODELVIEW_NORMAL_MATRIX * BINORMAL);
}

void fragment() {
	vec4 tex_color = texture(albedo_texture, UV);
	ALBEDO = albedo_color.rgb * tex_color.rgb;
}