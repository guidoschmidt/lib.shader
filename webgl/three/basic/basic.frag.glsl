uniform vec2 uResolution;
uniform sampler2D uTexture;

void main() {
  vec2 uv = gl_FragCoord.xy / uResolution;
  gl_FragColor = vec4(0, 0, 0, 1);
}
