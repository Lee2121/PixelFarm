uniform float time;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	vertex_position.x += (10 * time * VertexColor[0]);
	vertex_position.y += (10 * time * VertexColor[1]);
	return transform_projection * vertex_position;
}
