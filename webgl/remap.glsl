float remap(in float value, in float min1, in float max1, in float min2, in float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

#pragma glslify: export(remap)
