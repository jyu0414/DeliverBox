import SpriteKit

public class Box: SKSpriteNode {
    
    public var cellPositionX = 0
    public var cellPositionY = 0
    public var cellOldPositionX = 0
    public var cellOldPositionY = 0
    public var colour = Pipes.Colour.Green
    public var direction = CGPoint(x: 0, y: 1)
    
    public init(colour: Pipes.Colour, pos: Pipes.Position, _ number: Int) {
        let img = NSImage(named: colour.rawValue + "Box.png")!
        super.init(texture: SKTexture(image: img), color: .clear, size: img.size)
        switch pos {
        case .Bottom:
            super.position.y = 95
            cellPositionY = 7
            direction = CGPoint(x: 0, y: -1)
            break
        case .Top:
            super.position.y = 1218
            cellPositionY = -1
            break
        }
        super.position.x = CGFloat(168) + CGFloat(number * 142)
        self.colour = colour
        cellPositionX = number
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

