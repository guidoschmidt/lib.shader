uniform vec2 uResolution;
uniform sampler2D uTexture;

void main() {
  vec2 uv = gl_FragCoord.xy / uResolution;
  vec4 color = texture2D(uTexture, uv);
  if (uv.x <= 0.1) {
    color.rgb += 0.005;
  }
  gl_FragColor = color;
}
