float plot(in vec2 st, in float linewidth)
{
  return smoothstep(linewidth, 0.0, abs(st.y - st.x));
}

float plot(in vec2 st, float pct, float linewidth) {
  return
    smoothstep(pct - linewidth, pct, st.y) -
    smoothstep(pct, pct + linewidth, st.y);
}

#pragma glslify: export(plot)
