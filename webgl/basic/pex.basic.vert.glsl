attribute vec3 aPosition;
attribute vec3 aNormal;

uniform mat4 uProjectionMatrix;
uniform mat4 uViewMatrix;

varying vec3 vNormal;

void main () {
  gl_Position = uProjectionMatrix * uViewMatrix * vec4(aPosition, 1.0);
  vNormal = aNormal;
}
