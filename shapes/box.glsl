float box(in vec2 uv, in vec2 size) {
  size = vec2(0.5) - size * 0.5;
  vec2 st = smoothstep(size, size + vec2(0.001), uv);
  st *= smoothstep(size, size + vec2(0.001), vec2(1.0) - uv);
  return st.x * st.y;
}

#pragma glslify: export(box)
