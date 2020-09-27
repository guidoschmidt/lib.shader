mat2 rotate_2d(float angle) {
  return mat2(cos(angle), -sin(angle),
              sin(angle), cos(angle));
}

#pragma glslify: export(rotate_2d)
