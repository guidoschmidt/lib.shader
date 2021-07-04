precision highp float;

// https://www.standardabweichung.de/code/javascript/webgl-glsl-fresnel-schlick-approximation
float fresnel(vec3 direction, vec3 normal, bool invert, float strength) {
  vec3 nDirection = normalize(direction);
  vec3 nNormal = normalize(normal);
  vec3 halfDirection = normalize(nNormal + nDirection);
  float cosine = dot(halfDirection, nDirection);
  float product = max(cosine, 0.0);
  float factor = invert ? 1.0 - pow(product, strength) : pow(product, strength);
  return factor;
}

#pragma glslify: export(fresnel)
