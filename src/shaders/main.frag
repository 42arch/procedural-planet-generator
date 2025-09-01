#include noise3D.glsl

varying vec3 vNormal;
varying float vElevation;
varying vec3 vPos;

void main() {
  float lat = abs(vNormal.y);
  float polarNoise = snoise(vNormal * 5.0) * 0.2; // 调节强度
  float polarFactor = smoothstep(0.6 + polarNoise, 1.0, lat);

  // 根据噪声高度分区
  vec3 oceanColor     = vec3(0.0, 0.2, 0.6);
  vec3 beachColor     = vec3(0.9, 0.8, 0.6);
  vec3 grassColor     = vec3(0.1, 0.5, 0.1);
  vec3 forestColor    = vec3(0.0, 0.3, 0.0);
  vec3 desertColor    = vec3(0.9, 0.8, 0.4);
  vec3 mountainColor  = vec3(0.5, 0.5, 0.5);
  vec3 snowColor      = vec3(1.0, 1.0, 1.0);

  vec3 color;

  // 海洋 vs 陆地
  if (vElevation < -0.01) {
    color = oceanColor;
  } else {
    // 沙滩
    if (vElevation < 0.02) {
      color = beachColor;
    }
    // 低纬度 -> 沙漠
    else if (lat < 0.2) {
      color = desertColor;
    }
    // 中纬度 -> 草地 / 森林
    else if (lat < 0.6) {
      color = (vElevation > 0.5) ? forestColor : grassColor;
    }
    // 高山区域
    else if (vElevation > 0.75) {
      color = (vElevation > 0.4) ? mountainColor : snowColor;
    }
    // 极地雪帽
    else if (lat > 0.75) {
      float rugged = smoothstep(0.7, 1.0, vElevation + lat * 0.5);
      color = (rugged > 0.6) ? snowColor : mountainColor;
    }
    // 默认草地
    else {
      color = grassColor;
    }
  }

  gl_FragColor = vec4(color + 0.1, 1.0);
}