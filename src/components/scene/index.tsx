import { GizmoHelper, GizmoViewport, OrbitControls, Stars } from '@react-three/drei'
import { Canvas } from '@react-three/fiber'
import Planet from './planet'

export default function Scene() {
  return (
    <Canvas>
      <color attach="background" args={['#000']} />
      <ambientLight intensity={Math.PI / 2} />
      <spotLight position={[10, 10, 10]} angle={0.15} penumbra={1} decay={0} intensity={Math.PI} />
      <pointLight position={[-10, -10, -10]} decay={0} intensity={Math.PI} />

      <Planet />
      <Stars count={1000} saturation={0.1} fade={true} radius={200} />

      <OrbitControls minDistance={1} maxDistance={300} />

      <GizmoHelper
        alignment="bottom-right"
        margin={[80, 80]}
      >
        <GizmoViewport axisColors={['red', 'green', 'blue']} labelColor="black" />
      </GizmoHelper>
    </Canvas>
  )
}
