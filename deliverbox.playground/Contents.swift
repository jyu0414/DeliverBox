import PlaygroundSupport
import SpriteKit

class GameScene: SKScene {
    
    var tiles: [[Tile]] = []
    var pipes: [Pipes] = []
    var boxes: [Box] = []
    
    let boardPosition = CGPoint(x: 168, y: 1087)
    let cellGap = 2;
    let cellHeightWidth = 141;
    
    let commandButtons = [Tile(state: .Up),Tile(state: .Down),Tile(state: .Left),Tile(state: .Right)]
    let dragTile = Tile(state: .Hide)
    
    var level = 0 {
        didSet {
            levelText.text = "\(level)"
            scoreLimitText.text = "/  \(1000 + 100 * level)"
        }
    }
    var highestLevel = 3
    var tickCount = 0
    var gameScore = 0 {
        didSet {
            scoreText.text = toStringWithLength(x: gameScore, length: 5)
        }
    }
    
    var popupViewNodes: [SKNode] = []
    var popupLevelLabel: SKLabelNode?
    
    let scoreText = SKLabelNode(text: "00500")
    let scoreLimitText = SKLabelNode(text: "/ 01000")
    let levelText = SKLabelNode(text: "0")
    
    var levelTemplateColor = [
    [ [ nil, nil, nil, Pipes.Colour.Green, nil, nil, nil, nil ], [ nil, nil, nil, nil, Pipes.Colour.Green, nil, nil, nil ] ],
    [ [ nil, nil, nil, Pipes.Colour.Green, nil, Pipes.Colour.Pink, nil, nil ], [ nil, nil, nil, nil, Pipes.Colour.Green, nil, Pipes.Colour.Pink, nil ] ],
    [ [ nil, Pipes.Colour.Pink, nil, nil, nil, nil, Pipes.Colour.Green, nil ], [ nil, nil, nil, Pipes.Colour.Green, nil, nil, nil, Pipes.Colour.Pink ] ],
    [ [ Pipes.Colour.Green, nil, Pipes.Colour.Pink, nil, nil, nil, Pipes.Colour.Green, nil ], [ nil, nil, nil, nil, Pipes.Colour.Green, nil, nil, Pipes.Colour.Pink ] ],
    [ [ nil, Pipes.Colour.Pink, nil, Pipes.Colour.Purple, nil, nil, Pipes.Colour.Green, nil ], [ Pipes.Colour.Purple, nil, nil, nil, Pipes.Colour.Green, nil, nil, Pipes.Colour.Pink ] ],
    [ [ nil, Pipes.Colour.Pink, Pipes.Colour.Red, nil, nil, Pipes.Colour.Purple, nil, Pipes.Colour.Green ], [ Pipes.Colour.Red, nil, nil, Pipes.Colour.Pink, nil, Pipes.Colour.Green, nil, Pipes.Colour.Purple ] ],
    [ [ nil, Pipes.Colour.Pink, Pipes.Colour.Red, nil, nil, Pipes.Colour.Purple, nil, Pipes.Colour.Green ], [ Pipes.Colour.Green, Pipes.Colour.Red, nil, Pipes.Colour.Pink, nil, nil, nil, Pipes.Colour.Purple ] ]
    ]
    var levelTemplateInOut = [
    [ [ nil, nil, nil, Pipes.Kind.Pipe, nil, nil, nil, nil ], [ nil, nil, nil, nil, Pipes.Kind.Truck, nil, nil, nil ] ],
    [ [ nil, nil, nil, Pipes.Kind.Pipe, nil, Pipes.Kind.Truck, nil, nil ], [ nil, nil, nil, nil, Pipes.Kind.Truck, nil , Pipes.Kind.Pipe, nil ] ],
    [ [ nil, Pipes.Kind.Truck, nil, nil, nil, nil, Pipes.Kind.Pipe, nil ], [ nil, nil, nil, Pipes.Kind.Truck, nil, nil , nil, Pipes.Kind.Pipe ] ],
    [ [ Pipes.Kind.Truck, nil, Pipes.Kind.Truck, nil, nil, nil, Pipes.Kind.Pipe, nil ], [ nil, nil, nil, nil, Pipes.Kind.Truck, nil , nil, Pipes.Kind.Pipe ] ],
    [ [ nil, Pipes.Kind.Truck, nil, Pipes.Kind.Pipe, nil, nil, Pipes.Kind.Pipe, nil ], [ Pipes.Kind.Truck, nil, nil, nil, Pipes.Kind.Truck, nil , nil, Pipes.Kind.Pipe ] ],
    [ [ nil, Pipes.Kind.Pipe, Pipes.Kind.Truck, nil, nil, Pipes.Kind.Pipe, nil, Pipes.Kind.Pipe], [Pipes.Kind.Pipe, nil, nil, Pipes.Kind.Truck, nil, Pipes.Kind.Truck , nil, Pipes.Kind.Truck ] ],
    [ [ nil, Pipes.Kind.Pipe, Pipes.Kind.Truck, nil, nil, Pipes.Kind.Pipe, nil, Pipes.Kind.Truck], [Pipes.Kind.Pipe, Pipes.Kind.Pipe, nil, Pipes.Kind.Truck, nil, nil , nil, Pipes.Kind.Truck ] ]
    ]
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1737, height: 1303)
        backgroundColor = NSColor(red: 107/255, green: 126/255, blue: 142/255, alpha: 1)
        
        //Make Board
        for x in 0 ..< 8
        {
            tiles.append([Tile]())
            for y in 0 ..< 7
            {
                let newTile = Tile(state: .Normal)
                tiles[x].append(newTile)
                newTile.position = CGPoint(x: Int(boardPosition.x) + ((cellHeightWidth + cellGap) * x), y: Int(boardPosition.y) - ((cellHeightWidth + cellGap) * y))
                newTile.name = "tile"
                addChild(newTile)
            }
        }
        
        //Make SideBar
        let scorePanel = SKSpriteNode(imageNamed: "scoreBackPanel.png")
        scorePanel.position = CGPoint(x: 1542, y: 1153)
        addChild(scorePanel)
        let levelPanel = SKSpriteNode(imageNamed: "levelBackPanel.png")
        levelPanel.position = CGPoint(x: 1542, y: 951)
        addChild(levelPanel)
        let commandPanel = SKSpriteNode(imageNamed: "commandBackPanel.png")
        commandPanel.position = CGPoint(x: 1542, y: 445)
        addChild(commandPanel)
        
        scoreText.position = CGPoint(x: 1522, y: 1165)
        scoreLimitText.position = CGPoint(x: 1620, y: 1125)
        levelText.position = CGPoint(x: 1542, y: 940)
        scoreText.fontName = "ArialRoundedMTBold"
        scoreText.fontColor = NSColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        levelText.fontName = "ArialRoundedMTBold"
        levelText.fontColor = NSColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        scoreLimitText.fontName = "ArialRoundedMTBold"
        scoreLimitText.fontColor = NSColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        scoreText.fontSize = 60
        scoreLimitText.fontSize = 30
        levelText.fontSize = 80
        addChild(scoreText)
        addChild(scoreLimitText)
        addChild(levelText)
        
        
        //Make Command Button
        commandButtons[0].position = CGPoint(x: 1545, y: 725)
        commandButtons[1].position = CGPoint(x: 1545, y: 554)
        commandButtons[2].position = CGPoint(x: 1545, y: 383)
        commandButtons[3].position = CGPoint(x: 1545, y: 212)
        commandButtons[0].name = "commandButton"
        commandButtons[1].name = "commandButton"
        commandButtons[2].name = "commandButton"
        commandButtons[3].name = "commandButton"
        commandButtons.forEach(){self.addChild($0)}
        
        dragTile.position = CGPoint(x: 0,y: 0)
        addChild(dragTile)
        
        showStartView()
        
    }
    
    func setLevel(level: Int)
    {
        boxes.forEach({$0.removeFromParent()})
        boxes = []
        pipes.forEach({$0.removeFromParent()})
        pipes = []
        
        for tiless in tiles {
            for tile in tiless {
                tile.state = .Normal
            }
        }
        for pos in 0...1 {
            for num in 0...7 {
                if levelTemplateInOut[level][pos][num] != nil {
                    var p =  Pipes.Position.Bottom
                    if pos == 0 {
                        p = .Top
                    }
                    let pipe = Pipes(kind: levelTemplateInOut[level][pos][num]!, colour: levelTemplateColor[level][pos][num]!, pos: p, num)
                    
                    pipes.append(pipe)
                    addChild(pipe)
                }
            }
        }
        
    }
    
    func showStartView()
    {
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPoint(x: 879, y: 640)
        popupViewNodes.append(background)
        addChild(background)
        
        let title = SKLabelNode(text: "Load boxes on the truck!")
        title.position = CGPoint(x: 879, y: 750)
        title.fontName = "ArialRoundedMTBold"
        title.fontColor = NSColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        title.fontSize = 80
        popupViewNodes.append(title)
        addChild(title)
        
        let levelLabel = SKLabelNode(text: "LEVEL \(self.level)")
        levelLabel.position = CGPoint(x: 879, y: 600)
        levelLabel.fontName = "ArialRoundedMTBold"
        levelLabel.fontColor = NSColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
        levelLabel.fontSize = 60
        popupViewNodes.append(levelLabel)
        popupLevelLabel = levelLabel
        addChild(levelLabel)
        
        let leftButton = SKSpriteNode(imageNamed: "leftButton.png")
        leftButton.position = CGPoint(x: 650, y: 623)
        popupViewNodes.append(leftButton)
        leftButton.name = "leftButton"
        addChild(leftButton)
        
        let rightButton = SKSpriteNode(imageNamed: "rightButton.png")
        rightButton.position = CGPoint(x: 1108, y: 623)
        popupViewNodes.append(rightButton)
        rightButton.name = "rightButton"
        addChild(rightButton)
        
        let start = SKLabelNode(text: "START")
        start.position = CGPoint(x: 879, y: 450)
        start.fontName = "ArialRoundedMTBold"
        start.fontColor = NSColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
        start.fontSize = 60
        popupViewNodes.append(start)
        addChild(start)
        
        let startButton = SKSpriteNode(imageNamed: "roundButton.png")
        startButton.name = "startButton"
        startButton.position = CGPoint(x: 879, y: 473)
        popupViewNodes.append(startButton)
        addChild(startButton)
    }
    
    func closeStartView()
    {
        popupViewNodes.forEach({$0.removeFromParent()})
        popupViewNodes = []
        popupLevelLabel = nil
        
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPoint(x: 879, y: 640)
        popupViewNodes.append(background)
        addChild(background)
        
        let title = SKLabelNode(text: "Geme Start")
        title.position = CGPoint(x: 879, y: 750)
        title.fontName = "ArialRoundedMTBold"
        title.fontColor = NSColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        title.fontSize = 80
        popupViewNodes.append(title)
        addChild(title)
        
        let levelLabel = SKLabelNode(text: "It's start in...")
        levelLabel.position = CGPoint(x: 879, y: 600)
        levelLabel.fontName = "ArialRoundedMTBold"
        levelLabel.fontColor = NSColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
        levelLabel.fontSize = 60
        popupViewNodes.append(levelLabel)
        popupLevelLabel = levelLabel
        addChild(levelLabel)
        
        let start = SKLabelNode(text: "3...")
        start.position = CGPoint(x: 879, y: 450)
        start.fontName = "ArialRoundedMTBold"
        start.fontColor = NSColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
        start.fontSize = 80
        popupViewNodes.append(start)
        addChild(start)
        gameScore = 500
        self.run(
            SKAction.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.run {start.text = "2..."},
            SKAction.wait(forDuration: 1),
            SKAction.run {start.text = "1..."},
            SKAction.wait(forDuration: 1),
            SKAction.run {start.text = "START"},
            SKAction.wait(forDuration: 1)
            ]), completion:
            {
                self.startGame()
        })
       
        
    }
    
    func startGame()
    {
        popupViewNodes.forEach({$0.removeFromParent()})
        popupViewNodes = []
        prepareForTick()
    }
    
    func prepareForTick()
    {
        if tickCount % 3 == 0 {
            for pipe in pipes.filter({$0.kind == .Pipe}) {
                let box = Box(colour: pipe.colour, pos: pipe.pos, pipe.cellPositionX)
                boxes.append(box)
                addChild(box)
            }
        }
        tickCount += 1
        tick()
    }
    
    func tick()
    {
        let group = DispatchGroup()
        for box in boxes {
            let nextPositionX = box.cellPositionX + Int(box.direction.x)
            let nextPositionY = box.cellPositionY + Int(box.direction.y)
            var action: SKAction
            if nextPositionX < 8 && nextPositionY < 7 && nextPositionY >= 0 && nextPositionX >= 0 {
                action = SKAction.move(to: tiles[nextPositionX][nextPositionY].position, duration: 1)
                
            }
            else {
                action = SKAction.moveBy(x: box.direction.x * 143, y: box.direction.y * -143, duration: 1)
            }
            group.enter()
            box.run(action, completion: {
                group.leave()
            })
            box.cellOldPositionX = box.cellPositionX
            box.cellOldPositionY = box.cellPositionY
            box.cellPositionX = nextPositionX
            box.cellPositionY = nextPositionY
            
        }
        group.notify(queue: .main) {
            self.run(SKAction.wait(forDuration: 0.5), completion: {
                self.didTick()
            })
            
        }
    }
    
    func combination<T> (list: Array<T>, cl: (T,T) -> Void)
    {
        if list.count <= 1 {
            return
        }
        var list2 = list
        for _ in 0..<list.count - 1 {
            let obj = list2.first
            list2.removeFirst()
            for obj2 in list2 {
                cl(obj!,obj2)
            }
            
        }
        
    }
    
    func didTick()
    {
        combination(list: boxes, cl: { box, box2 in
                if box.cellPositionY == box2.cellPositionY && box.cellPositionX == box2.cellPositionX {
                    endGame(reason: .Bump)
                    return
                }
                if box.cellOldPositionX == box2.cellPositionX && box.cellOldPositionY == box2.cellPositionY && box2.cellOldPositionX == box.cellPositionX && box2.cellOldPositionY == box.cellPositionY{
                    endGame(reason: .Bump)
                    return
                }
        })
        for box in boxes {
            
            if box.cellPositionX < 8 && box.cellPositionY < 7 && box.cellPositionY >= 0 && box.cellPositionX >= 0 {
                switch tiles[box.cellPositionX][box.cellPositionY].state {
                case .Down:
                    box.direction = CGPoint(x: 0, y: 1)
                    break
                case .Up:
                    box.direction = CGPoint(x: 0, y: -1)
                    break
                case .Left:
                    box.direction = CGPoint(x: -1, y: 0)
                    break
                case .Right:
                    box.direction = CGPoint(x: 1, y: 0)
                    break
                default:
                    break
                }
            }
            else {
                let poss = box.cellPositionY == -1 ? 0 : 1
                let text = SKLabelNode(fontNamed: "ArialRoundedMTBold")
                text.fontSize = 40
                text.position = box.position
                if box.cellPositionX >= 0 && box.cellPositionX <= 7 && levelTemplateInOut[level][poss][box.cellPositionX] == Pipes.Kind.Truck && levelTemplateColor[level][poss][box.cellPositionX] == box.colour
                {
                    gameScore += 100
                    text.text = "+100"
                    text.fontColor = NSColor.systemPink
                }
                else {
                    gameScore -= 100
                    text.text = "-100"
                    text.fontColor = NSColor.white
                }
                
                addChild(text)
                
                let group = DispatchGroup()
                group.enter()
                text.run(SKAction.moveBy(x: 0, y: 30, duration: 0.8), completion: {
                    group.leave()
                })
                group.enter()
                text.run(SKAction.fadeOut(withDuration: 1.2), completion: {
                    group.leave()
                })
                group.notify(queue: .main){
                    text.removeFromParent()
                }
                
                box.removeFromParent()
                boxes.remove(at: boxes.firstIndex(of: box)!)
            }
            
        }
        
        
        //レベルアップ
        if(gameScore >= 1000 + 100 * level)
        {
            if(level + 1 >= 7)
            {
                endGame(reason: .Complete)
            }
            else {
                levelUp()
            }
            
        }
        else if(gameScore <= 0)
        {
            endGame(reason: .GameOver)
        }
        else {
            prepareForTick()
        }
        
    }
    
    func levelUp() {
        level += 1
        if highestLevel < level
        {
            highestLevel = level;
        }
        gameScore = 500
        
        setLevel(level: level)
        popupViewNodes.forEach({$0.removeFromParent()})
        popupViewNodes = []
        popupLevelLabel = nil
        
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPoint(x: 879, y: 640)
        popupViewNodes.append(background)
        addChild(background)
        
        let title = SKLabelNode(text: "Geme Start")
        title.position = CGPoint(x: 879, y: 750)
        title.fontName = "ArialRoundedMTBold"
        title.fontColor = NSColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        title.fontSize = 80
        popupViewNodes.append(title)
        addChild(title)
        
        let levelLabel = SKLabelNode(text: "Level up \(level - 1)→\(level)")
        levelLabel.position = CGPoint(x: 879, y: 600)
        levelLabel.fontName = "ArialRoundedMTBold"
        levelLabel.fontColor = NSColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
        levelLabel.fontSize = 60
        popupViewNodes.append(levelLabel)
        popupLevelLabel = levelLabel
        addChild(levelLabel)
        
        let start = SKLabelNode(text: "3...")
        start.position = CGPoint(x: 879, y: 450)
        start.fontName = "ArialRoundedMTBold"
        start.fontColor = NSColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
        start.fontSize = 80
        popupViewNodes.append(start)
        addChild(start)
        gameScore = 500
        self.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 1),
                SKAction.run {start.text = "2..."},
                SKAction.wait(forDuration: 1),
                SKAction.run {start.text = "1..."},
                SKAction.wait(forDuration: 1),
                SKAction.run {start.text = "START"},
                SKAction.wait(forDuration: 1)
                ]), completion:
            {
                self.startGame()
        })
        
    }
    
    func endGame(reason: GameState) {
        
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPoint(x: 879, y: 640)
        popupViewNodes.append(background)
        addChild(background)
        
        var titleText: String
        var levelLabelText: String
        
        switch reason {
        case .Bump:
            titleText = "Game Over..."
            levelLabelText = "Bumped! Lv.\(level)"
            break
        case .Complete:
            titleText = "Congratulations!"
            levelLabelText = "You have reached highest level!"
            break
        case .GameOver:
            titleText = "Game Over..."
            levelLabelText = "You scored 0 point! Lv.\(level)"
            break
        
        }
        
        let title = SKLabelNode(text: titleText)
        title.position = CGPoint(x: 879, y: 750)
        title.fontName = "ArialRoundedMTBold"
        title.fontColor = NSColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        title.fontSize = 80
        popupViewNodes.append(title)
        addChild(title)
        
        let levelLabel = SKLabelNode(text: levelLabelText)
        levelLabel.position = CGPoint(x: 879, y: 600)
        levelLabel.fontName = "ArialRoundedMTBold"
        levelLabel.fontColor = NSColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
        levelLabel.fontSize = 60
        popupViewNodes.append(levelLabel)
        popupLevelLabel = levelLabel
        addChild(levelLabel)
        
        let start = SKLabelNode(text: "New")
        start.position = CGPoint(x: 879, y: 450)
        start.fontName = "ArialRoundedMTBold"
        start.fontColor = NSColor(red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
        start.fontSize = 60
        popupViewNodes.append(start)
        addChild(start)
        
        let startButton = SKSpriteNode(imageNamed: "roundButton.png")
        startButton.name = "resetButton"
        startButton.position = CGPoint(x: 879, y: 473)
        popupViewNodes.append(startButton)
        addChild(startButton)
    }
    
    override func mouseDown(with event: NSEvent) {

        let touch = event.location(in: self)
        
        if let commandButton = self.nodes(at: touch).filter({$0.name == "commandButton"}).first {
            dragTile.position = touch
            dragTile.state = (commandButton as! Tile).state
        }
        
        if self.nodes(at: touch).filter({$0.name == "leftButton"}).first != nil{
            if level > 0 {
                level -= 1
            }
            popupLevelLabel?.text = "LEVEL \(self.level)"
        }
        
        if self.nodes(at: touch).filter({$0.name == "rightButton"}).first != nil{
            if level < 6 && level < highestLevel{
                level += 1
            }
            popupLevelLabel?.text = "LEVEL \(self.level)"
        }
        
        if self.nodes(at: touch).filter({$0.name == "startButton"}).first != nil{
            setLevel(level: level)
            closeStartView()
        }
        
        if self.nodes(at: touch).filter({$0.name == "tile"}).first != nil{
            (self.nodes(at: touch).filter({$0.name == "tile"}).first as! Tile).state = .Normal
        }
        
        if self.nodes(at: touch).filter({$0.name == "resetButton"}).first != nil{
            showStartView()
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        dragTile.position = event.location(in: self)
    }
    
    override func mouseUp(with event: NSEvent) {
        if dragTile.state != .Hide {
            let touch = event.location(in: self)
            (self.nodes(at: touch).filter({$0.name == "tile"}).first as? Tile)?.state = dragTile.state
            dragTile.state = .Hide
        }
    }
    
    func toStringWithLength(x: Int,length: Int) -> String
    {
        var tmp = "\(x)"
        while tmp.count < length {
            tmp = "0" + tmp
        }
        return tmp
    }
}

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 700, height: 600))
let scene = GameScene()
scene.scaleMode = .aspectFit
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
