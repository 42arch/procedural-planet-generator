import type { Scene } from 'three'
import {
  BufferGeometry,
  Color,
  Float32BufferAttribute,
  Points,
  PointsMaterial,
  TextureLoader,
  Vector3,
} from 'three'

interface StarFieldParams {
  count: number
  radius: number
}

class StarField {
  private scene: Scene
  private count: number
  private radius: number
  private points?: Points

  constructor(scene: Scene, { count, radius }: StarFieldParams) {
    this.scene = scene
    this.count = count
    this.radius = radius
    this.addToScene()
  }

  randomSpherePoint() {
    const radius = Math.random() * this.radius + this.radius
    const u = Math.random()
    const v = Math.random()
    const theta = 2 * Math.PI * u
    const phi = Math.acos(2 * v - 1)
    const x = radius * Math.sin(phi) * Math.cos(theta)
    const y = radius * Math.sin(phi) * Math.sin(theta)
    const z = radius * Math.cos(phi)
    return {
      position: new Vector3(x, y, z),
      hue: 0.9,
      minDistance: radius,
    }
  }

  addToScene() {
    const verts = []
    const colors = []
    const positions = []
    let color

    for (let i = 0; i < this.count; i++) {
      const point = this.randomSpherePoint()
      const { position, hue } = point
      positions.push(point)
      color = new Color().setHSL(hue, 0.2, Math.random())
      verts.push(position.x, position.y, position.z)
      colors.push(color.r, color.g, color.b)
    }

    const geometry = new BufferGeometry()
    geometry.setAttribute('position', new Float32BufferAttribute(verts, 3))
    geometry.setAttribute('color', new Float32BufferAttribute(colors, 3))

    const material = new PointsMaterial({
      size: 0.4,
      vertexColors: true,
      map: new TextureLoader().load('/star.png'),
    })

    this.points = new Points(geometry, material)
    this.scene.add(this.points)
  }

  update({ count, radius }: StarFieldParams) {
    this.count = count
    this.radius = radius
    if (this.points) {
      this.scene.remove(this.points)
    }
    this.addToScene()
  }
}

export default StarField
