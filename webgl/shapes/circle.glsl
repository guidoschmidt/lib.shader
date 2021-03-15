float circle(in vec2 uv, in float radius) {
  vec2 d = uv - vec2(0.5);
  return 1.0 - smoothstep(radius - (radius * 0.01),
                          radius + (radius * 0.01),
                          dot(d, d) * 4.0);
}

#pragma glslify: export(circle)
