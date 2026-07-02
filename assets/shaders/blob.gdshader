shader_type canvas_item;

uniform vec4 blob_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float threshold = 0.5;

// Define your blobs here (e.g., position, radius)
uniform vec2 blob1_pos = vec2(300.0, 200.0);
uniform float blob1_radius = 50.0;
uniform vec2 blob2_pos = vec2(400.0, 250.0);
uniform float blob2_radius = 60.0;

void fragment() {
    // Calculate distance field for blobs
    vec2 uv = FRAGCOORD.xy;
    
    float dist1 = blob1_radius / length(uv - blob1_pos);
    float dist2 = blob2_radius / length(uv - blob2_pos);
    
    // Combine the fields
    float total = dist1 + dist2;
    
    // Smoothstep creates the sharp, blobby merging edge
    float alpha = smoothstep(threshold - 0.05, threshold + 0.05, total);
    
    COLOR = blob_color;
    COLOR.a = alpha;
}