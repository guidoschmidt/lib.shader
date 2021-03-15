uniform vec2 uResolution;
uniform sampler2D uTexture;

void main() {
  vec2 uv = gl_FragCoord.xy / uResolution;
  vec4 color = vec4(0, 0, 0, 0);
  if (uv.x <= 0.6 && uv.x >= 0.4 &&
      uv.y <= 0.6 && uv.y >= 0.4) {
    color.rgb += 1.0;
  }
  gl_FragColor = color;
}
