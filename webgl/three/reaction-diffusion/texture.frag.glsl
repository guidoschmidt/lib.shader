precision highp float;

#pragma glslify: blur = require('glsl-fast-gaussian-blur/13')

uniform int uFrame;
uniform float uTime;
uniform vec2 uResolution;
uniform vec3 uMouse;
uniform vec4 uDiffusionSettings;
// x: diffusionRateA
// y: diffusionRateB
// z: feedRate
// w: killRate
uniform vec4 uBrush;
uniform sampler2D uTexture;
uniform sampler2D uAudioTexture;

varying vec2 vUv;

float circle(in vec2 uv, in vec2 position, in float radius) {
  vec2 d = uv - position;
  return 1.0 - smoothstep(radius - (radius * 0.01),
                          radius + (radius * 0.01),
                          dot(d, d) * 4.0);
}

void main() {
  vec2 uv = vUv;
  vec4 ad = texture2D(uAudioTexture, uv);


  float radius = 0.75;
  float angle = 3.14159 * ad.r;
  vec2 tc = uv;
  tc -= vec2(0.5);
  float dist = length(tc);
  if (dist < radius) 
  {
    float percent = (radius - dist) / radius;
    float theta = percent * percent * angle * 8.0 + ad.g;
    float s = sin(theta);
    float c = cos(theta);
    tc = vec2(dot(tc, vec2(c, -s)), dot(tc, vec2(s, c)));
  }

  // vec4 audioData = blur(uAudioTexture, uv, uResolution, vec2(1, 1));
  vec4 audioData = clamp(texture2D(uAudioTexture, uv), 0.0, 1.0);
  // audioData.r = pow(audioData.r, 2.0);

  vec2 uvc = uv - vec2(0.5);
  float d = sqrt(dot(uvc, uvc));
  float t = 1.0 - smoothstep(0.0, 1.0, d);

  // float smooth_circle = 1.0 - smoothstep(0.0, 0.75, d);
  // audioData.r *= smooth_circle;

  vec3 color = vec3(0.0);
  color = texture2D(uTexture, uv).rgb;

  float diffusionRateA = uDiffusionSettings.x;
  float diffusionRateB = uDiffusionSettings.y;
  float feedRate = uDiffusionSettings.z;
  float killRate = uDiffusionSettings.w;

  // diffusionRateB -= smooth_circle / 2.0;
  // feedRate += (audioData.r - 0.5) / 500.0;
  // feedRate += smoothstep(0.0, 0.6, d) * audioData.r / 700.0;
  // killRate -= (audioData.r - 0.5) / 700.0;
  // killRate -= smoothstep(0.0, 0.6, d) / 300.0;

  // Reaction diffusion
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
               (laplace.r * diffusionRateA) -
               oldState.r * oldState.g * oldState.g +
               feedRate * (1.0 - oldState.r);
  newState.g = oldState.g +
               (laplace.g * diffusionRateB) +
               oldState.r * oldState.g * oldState.g -
               (killRate + feedRate) * oldState.g;

  // Drawing
  newState.g += circle(uv, uMouse.xy, uBrush.x) * uMouse.z * 0.01;

  newState.g += pow(audioData.r, 20.0) * 0.01; // circle(uv, vec2(audioData.r), pow(audioData.g, 2.0)) * 0.01; 
  newState.r -= circle(uv, vec2(-audioData.r), pow(audioData.g, 3.0)) * 0.01; 

  // gl_FragColor = vec4(newState.rg, 0.0, 1.0);


  float pixelX = mod(float(uFrame), uResolution.x);
  float pixelY = float(uFrame) / uResolution.x;

  vec2 uvS = vec2(uv.x * uResolution.x, (1.0 - uv.y) * uResolution.y);
  if (floor(uvS.x) == floor(pixelX) &&
      floor(uvS.y) == floor(pixelY)) {
    // color = vec3(pixelX / uResolution.x);
    color = vec3(texture2D(uAudioTexture, uv).g);
  } 

    // color = vec3(1.0);


  gl_FragColor = vec4(color, 1.0);
}
