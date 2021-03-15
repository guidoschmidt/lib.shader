uniform vec2 uResolution;
uniform sampler2D uTexture;

varying vec2 vUv;

void main() {
  vec2 uv = vUv;
  vec4 color = vec4(0, 1.0, 0, 0);
  gl_FragColor = color;
}
