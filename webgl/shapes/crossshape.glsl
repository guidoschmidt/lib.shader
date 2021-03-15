#pragma glslify: box = require(./box)

float crossShape(in vec2 uv, float size) {
  return
    box(uv, vec2(size, size / 4.0)) +
    box(uv, vec2(size / 4.0, size));
}

#pragma glslify: export(crossShape)
