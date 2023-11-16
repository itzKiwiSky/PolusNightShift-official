  extern float elapsed = 10;

vec2 radialDistortion(vec2 coord, float dist) 
{
  vec2 cc = coord - 0.5;
  dist = dot(cc, cc) * dist + cos(elapsed * .3) * .01;
  return (coord + cc * (1.0 + dist) * dist);
}


vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc) 
{
  vec2 tcr = radialDistortion(tc, .24)  + vec2(.001, 0);
  vec2 tcg = radialDistortion(tc, .20);
  vec2 tcb = radialDistortion(tc, .18) - vec2(.001, 0);
  vec4 res = vec4(Texel(tex, tcr).r, Texel(tex, tcg).g, Texel(tex, tcb).b, 1)
    - cos(tcg.y * 128. * 3.142 * 2) * .03
    - sin(tcg.x * 128. * 3.142 * 2) * .03;
  return res * Texel(tex, tcg).a;
}