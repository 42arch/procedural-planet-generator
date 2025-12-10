import fragment from '@/shaders/planet/fragement.glsl'
import vertex from '@/shaders/planet/vertex.glsl'

export default function Planet() {
  return (
    <>
      <mesh>
        <icosahedronGeometry args={[1, 32]} />
        <shaderMaterial
          transparent
          wireframe
          vertexShader={vertex}
          fragmentShader={fragment}
        />
        {/* <meshBasicMaterial color="cyan" wireframe /> */}
      </mesh>
    </>
  )
}
