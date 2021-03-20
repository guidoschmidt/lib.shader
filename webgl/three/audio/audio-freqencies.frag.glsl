varying vec2 vUv;

uniform float uAverageFrequency;
uniform float uFrequencies[64];
uniform vec2 uResolution;

float MAX_LOG = 5.541263545158426;

void main() {
  vec2 uv = vUv;
  ivec2 iuv = ivec2(uv * 64.0);
  float spectrum = clamp(log(uFrequencies[iuv.x]) / MAX_LOG, 0.0, MAX_LOG);
  vec2 uv_t = uv + vec2(0.5);
  gl_FragColor = vec4(spectrum, uAverageFrequency / 255.0, 0, 1);
}
