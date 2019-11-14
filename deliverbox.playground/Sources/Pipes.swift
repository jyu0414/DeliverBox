import SpriteKit

public class Pipes: SKSpriteNode {
    
    public var cellPositionX: Int = 0
    public var cellPositionY: Int = 0
    public var kind: Kind = .Pipe
    public var colour: Colour = .Pink
    public var pos: Position = .Bottom
    
    public init(kind: Kind, colour: Colour, pos: Position, _ boxNumber: Int){
        let bgImage = NSImage(named: colour.rawValue + kind.rawValue + pos.rawValue + ".png")!
        super.init(texture: SKTexture(image: bgImage), color: NSColor.clear, size: bgImage.size)
        
        switch pos {
        case .Bottom:
            super.position.y = 95
            cellPositionY = 7
            break
        case .Top:
            super.position.y = 1218
            cellPositionY = -1
            break
        }
        cellPositionX = boxNumber
        self.kind = kind
        self.colour = colour
        self.pos = pos
        super.position.x = CGFloat(168) + CGFloat(boxNumber * 142)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public enum Kind: String {
        case Pipe = "Pipe"
        case Truck = "Truck"
    }
    
    public enum Colour: String {
        case Purple = "purple"
        case Green = "green"
        case Pink = "pink"
        case Red = "red"
    }
    
    public enum Position: String {
        case Top = "Top"
        case Bottom = "Bottom"
    }
}
