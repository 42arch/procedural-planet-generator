#include utils.glsl
#include fbm.glsl

varying vec3 vNormal;
varying float vElevation;
varying float vMoisture;
varying vec3 vPos;
uniform float uElevationSeed;
uniform float uElevationScale;
uniform int uElevationOctaves;
uniform float uElevationLacunarity;
uniform float uElevationPersistance;

uniform float uMoistureSeed;
uniform float uMoistureScale;
uniform int uMoistureOctaves;
uniform float uMoistureLacunarity;
uniform float uMoisturePersistance;
uniform float uTime;
uniform float uHeight;

void main() {
  vNormal = normal;
  vPos = normalize(position);

  // 计算噪声
  // float n = snoise(normalize(position) * 3.1 + vec3(0.05));
  float elevation = fbm(normalize(position) * 3.1 + vec3(0.05), uElevationSeed, uElevationScale, uElevationOctaves, uElevationLacunarity, uElevationPersistance);

  float moisture = fbm(normalize(position) * 3.1 + vec3(0.05), uMoistureSeed, uMoistureScale, uMoistureOctaves, uMoistureLacunarity, uMoisturePersistance);
  vElevation = elevation;
  vMoisture = moisture;

  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}