import type { ShaderMaterial } from 'three'
import { folder, useControls } from 'leva'
import { useEffect, useMemo, useRef } from 'react'
import { Color, FrontSide } from 'three'
import fragment from '@/shaders/planet/fragment.glsl'
import vertex from '@/shaders/planet/vertex.glsl'

export default function Planet() {
  const {
    seaLevel,
    iceThreshold,
    seed: elevationSeed,
    scale: elevationScale,
    octaves: elevationOctaves,
    persistance: elevationPersistance,
    lacunarity: elevationLacunarity,
    moistureSeed,
    moistureScale,
    moistureOctaves,
    moisturePersistance,
    moistureLacunarity,
  } = useControls({
    seaLevel: {
      value: 0.4,
      min: 0.00,
      max: 1.00,
      step: 0.01,
    },
    iceThreshold: {
      value: 0.8,
      min: 0.0,
      max: 1.0,
      step: 0.01,
    },
    elevation: folder({
      seed: {
        value: 1,
        min: 1,
        max: 99999,
        step: 1,
      },
      scale: {
        min: 0.1,
        max: 3,
        step: 0.001,
        value: 1,
      },
      octaves: {
        min: 1,
        max: 12,
        step: 1,
        value: 6,
      },
      persistance: {
        value: 0.6,
        min: 0.1,
        max: 1.2,
        step: 0.01,
      },
      lacunarity: {
        value: 2,
        min: 1,
        max: 8,
        step: 0.01,
      },
    }),
    moisture: folder({
      moistureSeed: {
        label: 'seed',
        value: 1,
        min: 1,
        max: 99999,
        step: 1,
      },
      moistureScale: {
        label: 'scale',
        min: 0.1,
        max: 3,
        step: 0.001,
        value: 1,
      },
      moistureOctaves: {
        label: 'octaves',
        min: 1,
        max: 12,
        step: 1,
        value: 6,
      },
      moisturePersistance: {
        label: 'persistance',
        value: 0.6,
        min: 0.1,
        max: 1.2,
        step: 0.01,
      },
      moistureLacunarity: {
        label: 'lacunarity',
        value: 2,
        min: 1,
        max: 8,
        step: 0.01,
      },
    }),
  })

  const materialRef = useRef<ShaderMaterial | null>(null)

  const uniforms = useMemo(
    () => ({
      uColor: { value: new Color('#000000') },
      uSeaLevel: { value: 0.4 },
      uIceThreshold: { value: 0.8 },
      uElevationSeed: { value: 1 },
      uElevationScale: { value: 1 },
      uElevationOctaves: { value: 1 },
      uElevationPersistance: { value: 0.6 },
      uElevationLacunarity: { value: 2 },
      uMoistureSeed: { value: 1 },
      uMoistureScale: { value: 1 },
      uMoistureOctaves: { value: 1 },
      uMoisturePersistance: { value: 0.6 },
      uMoistureLacunarity: { value: 2 },
    }),
    [],
  )

  useEffect(() => {
    const mat = materialRef.current
    if (!mat)
      return

    mat.uniforms.uElevationSeed.value = elevationSeed
    mat.uniforms.uElevationScale.value = elevationScale
    mat.uniforms.uElevationOctaves.value = elevationOctaves
    mat.uniforms.uElevationPersistance.value = elevationPersistance
    mat.uniforms.uElevationLacunarity.value = elevationLacunarity

    mat.uniforms.uSeaLevel.value = seaLevel
    mat.uniforms.uIceThreshold.value = iceThreshold
    mat.uniforms.uMoistureSeed.value = moistureSeed
    mat.uniforms.uMoistureScale.value = moistureScale
    mat.uniforms.uMoistureOctaves.value = moistureOctaves
    mat.uniforms.uMoisturePersistance.value = moisturePersistance
    mat.uniforms.uMoistureLacunarity.value = moistureLacunarity
  }, [
    elevationSeed,
    elevationScale,
    elevationOctaves,
    elevationPersistance,
    elevationLacunarity,
    moistureSeed,
    moistureScale,
    moistureOctaves,
    moisturePersistance,
    moistureLacunarity,
    seaLevel,
    iceThreshold,
  ])

  return (
    <>
      <mesh>
        <icosahedronGeometry args={[1, 200]} />
        <shaderMaterial
          transparent
          side={FrontSide}
          ref={materialRef}
          uniforms={uniforms}
          vertexShader={vertex}
          fragmentShader={fragment}
        />
      </mesh>
    </>
  )
}
