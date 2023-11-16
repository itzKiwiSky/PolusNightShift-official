extern vec2 objectPosition;
extern number radius;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) 
{
    vec4 pixel = Texel(texture, texture_coords);
    number distance = distance(objectPosition, screen_coords);
    number alpha = 1.0 - distance / radius;
    return vec4(pixel.rgb, alpha * pixel.a);
}