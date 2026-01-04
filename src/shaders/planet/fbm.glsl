#include noise3D.glsl

float snoiseWithSeed(vec3 v, float seed) {
  vec3 offset = vec3(
    sin(seed * 13.9898),
    sin(seed * 12.9898),
    sin(seed * 11.9898)
  );
  return snoise(v + offset);
}

float fbm(vec3 pos, float seed, float scale, int octaves, float lacunarity, float persistence) {
  float result = 0.0;
  float amplitude = 1.0;
  float maxAmplitude = 0.0;
  
  for (int i = 0; i < octaves; i++) {
    result += snoiseWithSeed(pos * scale, seed) * amplitude;
    maxAmplitude += amplitude;
    amplitude *= persistence;
    scale *= lacunarity;
  }
  
  return (result / maxAmplitude + 1.0) * 0.5;
}

// float fbm(vec3 pos, float seed, float scale, int octaves, float lacunarity, float persistence) {
//   vec3 positionScaled = pos * scale;
//   float result = 0.0;
//   float amplitude = 1.0;
//   float frequency = 1.0;

//   for (int i = 0; i < octaves; i++) {
//     result += snoiseWithSeed(positionScaled * frequency, seed) * amplitude;
//     // result += snoise(positionScaled * frequency) * amplitude;

//     amplitude *= persistence;
//     frequency *= lacunarity;
//   }

//   result = (result + 1.0) * 0.5;
//   return result;
// }