precision highp float;

highp mat4 axisAngleRotationMatrix(in highp vec3 n, in highp float theta) {
  // Using Rodrigues' formula, find a matrix which performs a rotation
  // about the axis n by theta radians
  float ct = cos(-theta);
  float st = sin(-theta);

  mat3 rod;
  rod[0][0] = (1.0 - ct) * n.x * n.x + ct;
  rod[1][0] = (1.0 - ct) * n.x * n.y + n.z * st;
  rod[2][0] = (1.0 - ct) * n.x * n.z - n.y * st;

  rod[0][1] = (1.0 - ct) * n.x * n.y - n.z * st;
  rod[1][1] = (1.0 - ct) * n.y * n.y + ct;
  rod[2][1] = (1.0 - ct) * n.y * n.z + n.x * st;

  rod[0][2] = (1.0 - ct) * n.x * n.z + n.y * st;
  rod[1][2] = (1.0 - ct) * n.y * n.z - n.x * st;
  rod[2][2] = (1.0 - ct) * n.z * n.z + ct;
  mat4 rotmatrix = mat4(rod);
  return rotmatrix;
}

#pragma glslify: export(axisAngleRotationMatrix)
