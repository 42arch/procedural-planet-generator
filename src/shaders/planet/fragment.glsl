#include noise3D.glsl

varying vec3 vNormal;
varying float vElevation;
varying float vMoisture;
varying vec3 vPos;
uniform float uSeaLevel;

vec3 getBiomeStyle(float elevation, float moisture, float seaLevel) {
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

  // Define elevation thresholds based on sea level
  float deepOceanLevel = seaLevel * 0.75;  // Deep ocean below this
  float shallowOceanLevel = seaLevel;      // Shallow ocean up to sea level
  float beachLevel = seaLevel * 1.15;      // Beach just above sea level
  float lowlandLevel = seaLevel * 1.3;     // Lowlands
  float highlandLevel = seaLevel * 1.6;    // Highlands
  float mountainLevel = seaLevel * 1.9;    // Mountains
  float snowLevel = seaLevel * 2.2;        // Snow line

  // Ocean with depth-based gradient
  if (elevation < shallowOceanLevel) {

    vec3 DEEP_OCEAN = vec3(0.252, 0.008, 0.000);    // rgba(252, 8, 0, 1) - very deep ocean

    // vec3 DEEP_OCEAN = vec3(0.055, 0.098, 0.162);    // #0e1928 - very deep ocean
    vec3 NORMAL_OCEAN = vec3(0.165, 0.294, 0.486);  // #2a4b7c - normal ocean
    vec3 SHALLOW_OCEAN = vec3(0.322, 0.612, 0.902); // #529ce6 - shallow ocean
    
    float depthFactor = (elevation - deepOceanLevel * 0.5) / (shallowOceanLevel - deepOceanLevel * 0.5);
    depthFactor = clamp(depthFactor, 0.0, 1.0);
    
    if (elevation < deepOceanLevel * 0.5) {
      float t = elevation / (deepOceanLevel * 0.5);
      return mix(DEEP_OCEAN, NORMAL_OCEAN, t);
    } else {
      return mix(NORMAL_OCEAN, SHALLOW_OCEAN, depthFactor);
    }
  }

  if (elevation < beachLevel) return BEACH;

  // High elevation biomes (mountains)
  if (elevation > mountainLevel) {
    if (moisture < 0.1) return SCORCHED;
    if (moisture < 0.2) return BARE;
    if (elevation > 0.9) return SNOW;
    if (moisture < 0.5) return TUNDRA;
    return TUNDRA;
  }

  // Highland biomes
  if (elevation > highlandLevel) {
    if (moisture < 0.33) return TEMPERATE_DESERT;
    if (moisture < 0.66) return SHRUBLAND;
    return TAIGA;
  }

  // Lowland biomes
  if (elevation > lowlandLevel) {
    if (moisture < 0.16) return TEMPERATE_DESERT;
    if (moisture < 0.33) return GRASSLAND;
    if (moisture < 0.66) return TEMPERATE_DECIDUOUS_FOREST;
    return TEMPERATE_RAIN_FOREST;
  }

  // Coastal/lowest land biomes
  if (moisture < 0.16) return SUBTROPICAL_DESERT;
  if (moisture < 0.33) return GRASSLAND;
  if (moisture < 0.66) return TROPICAL_SEASONAL_FOREST;
  return TROPICAL_RAIN_FOREST;
}

void main() {
  float lat = abs(vNormal.y);
  float polarNoise = snoise(vNormal * 5.0) * 0.2; // 调节强度
  float polarFactor = smoothstep(0.6 + polarNoise, 1.0, lat);

  vec3 color;

  // color = vec3(vElevation);
  // color = vElevation >= 0.0 ? vec3(1.0, 1.0, 1.0) : vec3(0.0, 0.0, 0.0);
  color = getBiomeStyle(vElevation, vMoisture, uSeaLevel);

  gl_FragColor = vec4(color, 1.0);
}