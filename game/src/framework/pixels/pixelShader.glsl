const int MAX_PIXELS = 4096;

uniform vec2 cameraCoords;

uniform vec2 pixelPositions[MAX_PIXELS];
uniform vec4 pixelColors[MAX_PIXELS];

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) 
{
    for (int i = 0; i < MAX_PIXELS; i++)
	{
		if (pixelPositions[i] == screen_coords)
		{
			return vec4(1, 1, 1, 1);
		}
	}
	
	return color;
}
