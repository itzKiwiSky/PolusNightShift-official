extern number time;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) 
{
    vec2 uv = texture_coords.xy;
    uv.x += sin(uv.y * 10.0 + time * 2.0) * 0.02;
    return Texel(texture, uv) * color;
}