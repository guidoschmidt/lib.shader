precision highp float;

uniform float uTime;
uniform sampler2D uTexture;
uniform vec2 uResolution;
uniform vec3 uMouse;
uniform vec4 uDiffusionSettings;
// x: diffusionRateA
// y: diffusionRateB
// z: feedRate
// w: killRate
uniform vec4 uBrush;

varying vec2 vUv;

float circle(in vec2 uv, in vec2 position, in float radius) {
  vec2 d = uv - position;
  return 1.0 - smoothstep(radius - (radius * 0.01),
                          radius + (radius * 0.01),
                          dot(d, d) * 4.0);
}

void main() {
  vec2 uv = vUv;
  vec4 newState = vec4(0.0);
  vec4 oldState = texture2D(uTexture, uv);

  vec2 laplace = vec2(0.0);
  int range = 1;
  for (int x = -range; x <= range; x++) {
    for (int y = -range; y <= range; y++) {
      vec2 offset = vec2(x, y) / uResolution;
      vec2 value = texture2D(uTexture, uv + offset).rg;
      if (x == 0 && y == 0) {
        laplace += value * -1.0f;
      }
      if (x == 0 && ((y < 0) || (y > 0))) {
        laplace += value * 0.2f;
      }
      if (y == 0 && ((x < 0) || (x > 0))) {
        laplace += value * 0.2f;
      }
      if ((y < 0 && x < 0) ||
          (y > 0 && x < 0) ||
          (y > 0 && x > 0) ||
          (y < 0 && x > 0)) {
        laplace += value * 0.05f;
      }
    }
  }

  newState.r = oldState.r +
               (laplace.r * uDiffusionSettings.r) -
               oldState.r * oldState.g * oldState.g +
               uDiffusionSettings.z * (1.0 - oldState.r);
  newState.g = oldState.g +
               (laplace.g * uDiffusionSettings.g) +
               oldState.r * oldState.g * oldState.g -
               (uDiffusionSettings.w + uDiffusionSettings.z) * oldState.g;

  // Drawing
  newState.g += circle(uv, uMouse.xy, uBrush.x) * uMouse.z * 0.01;

  gl_FragColor = vec4(newState.rg, 0.0, 1.0);
}
