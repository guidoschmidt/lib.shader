uniform int uState;
uniform sampler2D uTexture;
uniform vec2 uResolution;
uniform vec3 uMouse;

float circle(in vec2 uv, in vec2 position, in float radius) {
  vec2 d = uv - position;
  return 1.0 - smoothstep(radius - (radius * 0.01),
                          radius + (radius * 0.01),
                          dot(d, d) * 4.0);
}

void main() {
  vec2 uv = gl_FragCoord.xy / uResolution;
  vec4 color = texture2D(uTexture, uv);

  color += circle(uv, uMouse.xy, 0.001) * uMouse.z;

  gl_FragColor = vec4(color.rgb, 1.0);
}
