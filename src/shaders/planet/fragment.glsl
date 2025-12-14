#include noise3D.glsl

varying vec3 vNormal;
varying float vElevation;
varying float vMoisture;
varying vec3 vPos;

vec3 getNatural1Style(float elevation, float moisture) {
  vec3 OCEAN                     = vec3(0.165, 0.294, 0.486); // #2a4b7c
  vec3 SHALLOW_OCEAN             = vec3(0.322, 0.612, 0.902); // #529ce6
  vec3 BEACH                     = vec3(0.851, 0.788, 0.639); // #d9c9a3
  vec3 TEMPERATE_DESERT          = vec3(0.859, 0.812, 0.635); // #dbcfa2
  vec3 SHRUBLAND                 = vec3(0.647, 0.714, 0.541); // #a5b68a
  vec3 TAIGA                     = vec3(0.482, 0.612, 0.396); // #7b9c65
  vec3 TEMPERATE_DECIDUOUS_FOREST= vec3(0.369, 0.608, 0.298); // #5e9b4c
  vec3 TEMPERATE_RAIN_FOREST     = vec3(0.216, 0.459, 0.306); // #37754e
  vec3 SUBTROPICAL_DESERT        = vec3(0.882, 0.776, 0.584); // #e1c695
  vec3 GRASSLAND                 = vec3(0.620, 0.796, 0.376); // #9ecb60
  vec3 TROPICAL_SEASONAL_FOREST  = vec3(0.290, 0.541, 0.235); // #4a8a3c
  vec3 TROPICAL_RAIN_FOREST      = vec3(0.145, 0.416, 0.227); // #256a3a
  vec3 SCORCHED                  = vec3(0.235, 0.235, 0.235); // #3c3c3c
  vec3 BARE                      = vec3(0.627, 0.627, 0.627); // #a0a0a0
  vec3 TUNDRA                    = vec3(0.773, 0.788, 0.702); // #c5c9b3
  vec3 SNOW                      = vec3(0.949, 0.961, 0.973); // #f2f5f8

  if (elevation < 0.2) {
    return elevation < 0.15 ? OCEAN : SHALLOW_OCEAN;
  }

  if (elevation < 0.23) return BEACH;

  if (elevation > 0.8) {
    if (moisture < 0.1) return SCORCHED;
    if (moisture < 0.2) return BARE;
    if (moisture < 0.5) return TUNDRA;
    return SNOW;
  }

  if (elevation > 0.6) {
    if (moisture < 0.33) return TEMPERATE_DESERT;
    if (moisture < 0.66) return SHRUBLAND;
    return TAIGA;
  }

  if (elevation > 0.3) {
    if (moisture < 0.16) return TEMPERATE_DESERT;
    if (moisture < 0.33) return GRASSLAND;
    if (moisture < 0.66) return TEMPERATE_DECIDUOUS_FOREST;
    return TEMPERATE_RAIN_FOREST;
  }

  if (moisture < 0.16) return SUBTROPICAL_DESERT;
  if (moisture < 0.33) return GRASSLAND;
  if (moisture < 0.66) return TROPICAL_SEASONAL_FOREST;
  return TROPICAL_RAIN_FOREST;
}

void main() {
  float lat = abs(vNormal.y);
  float polarNoise = snoise(vNormal * 5.0) * 0.2; // 调节强度
  float polarFactor = smoothstep(0.6 + polarNoise, 1.0, lat);

  vec3 oceanColor     = vec3(0.0, 0.2, 0.6);
  vec3 beachColor     = vec3(0.9, 0.8, 0.6);
  vec3 grassColor     = vec3(0.1, 0.5, 0.1);
  vec3 forestColor    = vec3(0.0, 0.3, 0.0);
  vec3 desertColor    = vec3(0.9, 0.8, 0.4);
  vec3 mountainColor  = vec3(0.5, 0.5, 0.5);
  vec3 snowColor      = vec3(1.0, 1.0, 1.0);

  vec3 color;

  color = getNatural1Style(vElevation, vMoisture);

  gl_FragColor = vec4(color, 1.0);
}