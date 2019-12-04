import SpriteKit

class MenuScene: SKScene {
    
    var restartButton: ButtonNode!
    
    var background: SKSpriteNode!
    var water: SKSpriteNode!
    private var crocodile: SKSpriteNode!
    private var prize: SKSpriteNode!
    private var sliceSoundAction: SKAction!
    private var splashSoundAction: SKAction!
    private var nomNomSoundAction: SKAction!
    private var levelOver = false
    private var vineCut = false
    
    let margin = CGFloat(30)
    
    var histolyticaButton: ButtonNode!
    
    let coinLeftLabel = SKLabelNode(fontNamed: "Courier-Bold")
    let coinRightLabel = SKLabelNode(fontNamed: "Courier-Bold")
    
    var lastUpdateTimeInterval: TimeInterval = 0
    
    var gameOver = false
    

    
    override func didMove(to view: SKView) {
        setUpScenery()
    }

    fileprivate func setUpScenery() {
        
        background = SKSpriteNode(imageNamed: ImageName.Background)
        
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = Layer.Background
        background.anchorPoint = CGPoint(x: 0,y: 0)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        
        water = SKSpriteNode(imageNamed: ImageName.Water)
        
        background.position = CGPoint(x: 0, y: 0)
        water.zPosition = Layer.Water
        water.anchorPoint = CGPoint(x: 0,y: 0)
        water.size = CGSize(width: self.size.width, height: self.size.height/100 * 21.39)
        
        
        addChild(water)
        
        addChild(background)
        
        // MARK: Add histolytica button
        restartButton = ButtonNode(iconName: HUD.ButtonRestart, text: String(GameConfiguration.RestartButtonText), onButtonPress: histolyticaPressed)
        histolyticaButton.position = CGPoint(x: size.width * 0.25, y: margin + histolyticaButton.size.height / 2)
        addChild(histolyticaButton)
    }
    
    func histolyticaPressed() {
        print("Histolytica pressed!")
    }
    
    
    
}
