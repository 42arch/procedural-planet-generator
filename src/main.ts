import {
  AmbientLight,
  AxesHelper,
  DirectionalLight,
  FrontSide,
  Group,
  IcosahedronGeometry,
  Mesh,
  PerspectiveCamera,
  Scene,
  ShaderMaterial,
  WebGLRenderer,
} from 'three'
import { OrbitControls } from 'three/examples/jsm/Addons.js'
import StarField from './elements/star-field'
import pane from './gui'
import { params, type Params } from './params'
import fbmFragement from './shaders/main.frag'
import fbmVertex from './shaders/main.vert'

class View {
  private width: number
  private height: number
  private pixelRatio: number
  private canvas: HTMLElement
  private scene: Scene
  private camera: PerspectiveCamera
  private renderer: WebGLRenderer
  private controls: OrbitControls
  private group: Group
  private params: Params
  private starField: StarField

  constructor(element: string, params: Params) {
    this.canvas = document.querySelector(element) as HTMLElement
    this.params = params
    this.width = window.innerWidth
    this.height = window.innerHeight
    this.pixelRatio = Math.min(window.devicePixelRatio, 2)
    this.scene = new Scene()
    this.camera = new PerspectiveCamera(
      75,
      this.width / this.height,
      0.0001,
      100000,
    )
    this.camera.position.set(0, 0, this.params.size * 0.75)
    this.scene.add(this.camera)
    this.renderer = new WebGLRenderer({
      canvas: this.canvas,
      antialias: true,
      preserveDrawingBuffer: true,
    })

    this.renderer.setSize(this.width, this.height)
    this.renderer.setPixelRatio(this.pixelRatio)
    this.renderer.setClearColor(0x000000, 1)

    this.controls = new OrbitControls(this.camera, this.canvas)
    this.controls.enableDamping = true
    this.controls.maxDistance = this.params.size * 5
    this.controls.minDistance = this.params.size * 0.25

    this.group = new Group()
    // this.scene.add(this.group)

    this.starField = new StarField(this.scene, { count: 5000, radius: this.params.size * 3 })

    this.resize()
    // this.addLight()
    this.addHelper()
    this.render()
    this.animate()
  }

  resize() {
    window.addEventListener('resize', () => {
      this.width = window.innerWidth
      this.height = window.innerHeight

      this.camera.aspect = this.width / this.height
      this.camera.updateProjectionMatrix()

      this.renderer.setSize(this.width, this.height)
      this.renderer.setPixelRatio(this.pixelRatio)
    })
  }

  animate() {
    // const delta = this.clock.getDelta()

    this.renderer.render(this.scene, this.camera)
    this.controls.update()
    window.requestAnimationFrame(this.animate.bind(this))
  }

  addLight() {
    const ambientLight = new AmbientLight(0xFFFFFF, 4)
    this.scene.add(ambientLight)

    const directionalLight = new DirectionalLight(0xFFFFFF, Math.PI)
    directionalLight.position.set(4, 0, 2)
    directionalLight.castShadow = true
    this.scene.add(directionalLight)
  }

  addHelper() {
    const helper = new AxesHelper(this.params.size / 2)
    this.scene.add(helper)
  }

  createFbmMaterial() {
    const size = this.params.size
    const cellSize = this.params.cellSize
    const elevation = this.params.elevation
    const moisture = this.params.moisture

    const material = new ShaderMaterial({
      uniforms: {
        uSize: { value: size },
        uCellSize: { value: cellSize },
        uOpacity: { value: this.params.opacity },
        uStyle: { value: this.params.style },
        uElevationSeed: { value: elevation.seed },
        uElevationScale: { value: elevation.scale },
        uElevationOctaves: { value: elevation.octaves },
        uElevationLacunarity: { value: elevation.lacunarity },
        uElevationPersistance: { value: elevation.persistance },
        uMoistureSeed: { value: moisture.seed },
        uMoistureScale: { value: moisture.scale },
        uMoistureOctaves: { value: moisture.octaves },
        uMoistureLacunarity: { value: moisture.lacunarity },
        uMoisturePersistance: { value: moisture.persistance },
      },
      vertexShader: fbmVertex,
      fragmentShader: fbmFragement,
      transparent: false,
      side: FrontSide,
    })
    return material
  }

  addGrid() {
    const size = this.params.size
    const geometry = new IcosahedronGeometry(size / 4, 200)

    const material = this.createFbmMaterial()
    // const material = new MeshBasicMaterial({ color: 0x000000, wireframe: true })
    const mesh = new Mesh(geometry, material)

    this.group.add(mesh)
  }

  render() {
    this.addGrid()
  }

  rerender(params: Params) {
    this.group.clear()
    if (params.size !== this.params.size) {
      this.camera.position.setZ(this.params.size * 0.75)
    }
    this.params = params

    this.render()
  }

  export() {
    const canvas = this.renderer.domElement
    const dataURL = canvas.toDataURL('image/png')
    const link = document.createElement('a')
    link.href = dataURL
    link.download = 'planet.png'
    link.click()
  }
}

const view = new View('canvas.webgl', params)

pane.on('change', (e) => {
  if (e.last) {
    view.rerender(params)
    console.log(77777, params)
  }
})
