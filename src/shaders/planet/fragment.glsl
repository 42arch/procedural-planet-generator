#include noise3D.glsl

varying vec3 vNormal;
varying float vElevation;
varying float vMoisture;
varying vec3 vPos;
uniform float uSeaLevel;
uniform float uIceThreshold;

// Biome Colors
const vec3 OCEAN = vec3(0.165, 0.294, 0.486);
const vec3 SHALLOW_OCEAN = vec3(0.322, 0.612, 0.902);
const vec3 DEEP_OCEAN = vec3(0.1, 0.1, 0.2);
const vec3 BEACH = vec3(0.851, 0.788, 0.639);
const vec3 SNOW = vec3(0.95, 0.96, 0.98);

// Land Biomes (Whittaker-like)
const vec3 TROPICAL_RAIN_FOREST = vec3(0.145, 0.416, 0.227);
const vec3 TROPICAL_SEASONAL_FOREST = vec3(0.290, 0.541, 0.235);
const vec3 GRASSLAND = vec3(0.620, 0.796, 0.376);
const vec3 SUBTROPICAL_DESERT = vec3(0.882, 0.776, 0.584);
const vec3 TEMPERATE_RAIN_FOREST = vec3(0.216, 0.459, 0.306);
const vec3 TEMPERATE_DECIDUOUS_FOREST = vec3(0.369, 0.608, 0.298);
const vec3 SHRUBLAND = vec3(0.647, 0.714, 0.541);
const vec3 TAIGA = vec3(0.482, 0.612, 0.396);
const vec3 SCORCHED = vec3(0.235, 0.235, 0.235);
const vec3 TUNDRA = vec3(0.773, 0.788, 0.702);

vec3 getBiomeStyle(float elevation, float moisture, float temperature, float seaLevel) {
  // --- Ocean Logic ---
  if (elevation < seaLevel) {
    float deepLevel = seaLevel * 0.5;
    if (elevation < deepLevel) {
      return mix(DEEP_OCEAN, OCEAN, elevation / deepLevel);
    }
    return mix(OCEAN, SHALLOW_OCEAN, (elevation - deepLevel) / (seaLevel - deepLevel));
  }

  // --- Beach Logic ---
  if (elevation < seaLevel + 0.02) {
    return BEACH;
  }

  // --- Land Biome Logic (Based on Temperature & Moisture) ---
  
  // High Temperature (Tropics / Equator)
  if (temperature > 0.66) {
    if (moisture > 0.66) return TROPICAL_RAIN_FOREST;
    if (moisture > 0.33) return TROPICAL_SEASONAL_FOREST;
    if (moisture > 0.16) return GRASSLAND;
    return SUBTROPICAL_DESERT;
  }
  
  // Moderate Temperature (Temperate Zone)
  if (temperature > 0.33) {
    if (moisture > 0.66) return TEMPERATE_RAIN_FOREST;
    if (moisture > 0.33) return TEMPERATE_DECIDUOUS_FOREST;
    if (moisture > 0.16) return SHRUBLAND;
    return GRASSLAND;
  }
  
  // Low Temperature (Boreal / Tundra)
  if (temperature > 0.0) {
    if (moisture > 0.50) return TAIGA;
    return SHRUBLAND; 
  }

  // Freezing / Very Low Temp
  if (moisture > 0.1) return TUNDRA;
  return SCORCHED;
}

void main() {
  float lat = abs(vNormal.y); // 0.0 equator, 1.0 pole
  
  // 1. Calculate Base Temperature based on Latitude
  // Equator is hot (1.0), Poles are cold (0.0)
  float baseTemp = 1.0 - lat; 

  // 2. Elevation Cooling (Lapse Rate)
  // Higher elevation = Colder.
  float elevationCooling = max(0.0, vElevation - uSeaLevel) * 0.8;
  
  // 3. Noise influence for natural variation
  float tempNoise = snoise(vPos * 3.0) * 0.15; 
  
  // 4. Combine to get Local Temperature
  // We add uIceThreshold to shift the global freezing point.
  // Higher uIceThreshold -> Colder world (Ice expands) or Warmer?
  // Let's interpret uIceThreshold as "Ice Extent" (0 = no ice, 1 = full ice).
  // So we SUBTRACT uIceThreshold from temperature.
  // Mapping: 
  // uIceThreshold = 0.8 (Default) -> Should be normal.
  // Let's invert: uIceThreshold determines the "Freezing Latitude".
  // If uIceThreshold is high (0.9), ice is only at poles.
  // If uIceThreshold is low (0.1), ice covers almost everything.
  // Let's use the UI value directly as a "Coldness Offset".
  
  // Recalculating based on user prompt "control range":
  // Let's say uIceThreshold defines the latitude where temp hits 0 (freezing) ideally.
  float freezingLat = uIceThreshold; // e.g. 0.8
  
  // Adjust base temp so that at `lat == freezingLat`, `temp` is close to 0.
  // temp = (freezingLat - lat) ... positive if equator-ward, negative if pole-ward.
  float temperature = (freezingLat - lat);
  
  // Apply elevation cooling
  temperature -= elevationCooling;
  
  // Apply noise
  temperature += tempNoise;
  
  // Normalize temperature for biome lookups (roughly 0..1 range for land logic)
  // We shift it back up for biomes, assuming 0.0 is the snow line.
  float biomeTemp = clamp(temperature * 2.0 + 0.2, 0.0, 1.0); 

  vec3 color;
  
  // 5. Determine Ice Cap (Mutually Exclusive, High Priority)
  // If temperature is below zero, it's ice.
  // Use smoothstep for a sharp but anti-aliased boundary.
  
  float iceFactor = smoothstep(0.02, -0.02, temperature); // Sharp transition around 0.0

  if (iceFactor > 0.99) {
    color = SNOW;
  } else {
    vec3 biomeColor = getBiomeStyle(vElevation, vMoisture, biomeTemp, uSeaLevel);
    color = mix(biomeColor, SNOW, iceFactor);
  }

  gl_FragColor = vec4(color, 1.0);
}