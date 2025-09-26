// --- Example using sin for a different effect ---
shader_type canvas_item;

uniform float speed = 2.0;
uniform float strength = 0.01;
uniform float frequency = 15.0;

void fragment() {
    vec2 distorted_uv = UV;

    // Create a wave using sin.
    // We use TIME to make it move.
    // We add the tile's Y-coordinate (UV.y) to make the wave travel downwards.
    float wave = sin(TIME * speed + UV.y * frequency) * strength;

    // Apply the wave offset only to the x-coordinate to create a ripple.
    distorted_uv.x += wave;
    
    // Sample the texture with the new coordinates.
    COLOR = texture(TEXTURE, distorted_uv);
}