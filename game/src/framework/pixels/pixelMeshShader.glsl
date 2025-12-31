uniform float time;
uniform float speed;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	float xSpeed = (speed * time * (-1 + (VertexColor.r * 2)));
	float ySpeed = (speed * time * (-1 + (VertexColor.g * 2)));

	vertex_position.x += xSpeed;
	vertex_position.y += ySpeed;

	return transform_projection * vertex_position;
}
