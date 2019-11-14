import SpriteKit

open class Tile: SKSpriteNode {
    
    public var state: TileState{
        didSet {
            switch state {
            case .Hide:
                super.isHidden = true
                break
            default:
                super.isHidden = false
                super.texture = SKTexture(image: NSImage(named: state.rawValue) ?? NSImage(named: TileState.Normal.rawValue)!)
            }
        }
    }
    
    public init(state: TileState){
        self.state = state
        let bgImage = NSImage(named: state.rawValue) ?? NSImage(named: TileState.Normal.rawValue)!
        super.init(texture: SKTexture(image: bgImage), color: NSColor.clear, size: bgImage.size)
        super.isHidden = state == .Hide
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
