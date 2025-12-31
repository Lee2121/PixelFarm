uniform vec2 cameraCoords;

uniform float gridSize;
uniform vec4 lineColor;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) 
{
    // Calculate if the current pixel is near a grid line
    // mod(screen_coords.x, gridSize) gives the pixel's position within its current grid cell (0 to 32)
    // We check if this position is less than 1.0 (for a 1-pixel line thickness)
    float is_vertical_line = step(mod(screen_coords.x + cameraCoords.x, gridSize), 1.0);
    float is_horizontal_line = step(mod(screen_coords.y + cameraCoords.y, gridSize), 1.0);

    // Combine the checks: if either is a line, it is a line
    float is_line = max(is_vertical_line, is_horizontal_line);

	// Black background
    vec4 backgroundColor = vec4(0.0, 0.0, 0.0, 1.0); 

    // Mix the colors: if is_line is 1.0, use lineColor; otherwise use backgroundColor
    return mix(backgroundColor, lineColor, is_line);
}
