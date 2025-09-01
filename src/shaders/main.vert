#include utils.glsl
#include fbm.glsl

varying vec3 vNormal;
varying float vElevation;
varying vec3 vPos;
uniform float uElevationSeed;
uniform float uElevationScale;
uniform int uElevationOctaves;
uniform float uElevationLacunarity;
uniform float uElevationPersistance;
uniform float uTime;
uniform float uHeight;

void main() {
  vNormal = normal;
  vPos = normalize(position);

  // 计算噪声
  // float n = snoise(normalize(position) * 3.1 + vec3(0.05));
  float elevation = fbm(normalize(position) * 3.1 + vec3(0.05), uElevationSeed, uElevationScale, uElevationOctaves, uElevationLacunarity, uElevationPersistance);
  vElevation = elevation;

  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}