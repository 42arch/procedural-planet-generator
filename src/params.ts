interface NoiseOptions {
  seed: number
  scale: number
  octaves: number
  lacunarity: number
  persistance: number
  // redistribution: number
}

export interface Params {
  size: number
  cellSize: number
  opacity: number
  style: 1 | 2 | 3 // 'natural1' | 'natural2' | 'natural-dark'

  elevation: NoiseOptions
  moisture: NoiseOptions
}

export const params: Params = {
  size: 1000,
  cellSize: 2,
  opacity: 1,
  style: 1,
  elevation: {
    seed: getRandomNumber(1, 100000),
    scale: 0.7,
    octaves: 6,
    persistance: 0.6,
    lacunarity: 2,
  },
  moisture: {
    seed: getRandomNumber(1, 100000),
    scale: 0.8,
    octaves: 3,
    persistance: 0.5,
    lacunarity: 3,
  },
}

export function getRandomNumber(min: number, max: number) {
  return Math.floor(Math.random() * (max - min + 1)) + min
}
