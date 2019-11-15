import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background: SKSpriteNode!
    var water: SKSpriteNode!
    private var crocodile: SKSpriteNode!
    private var prize: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        setUpPhysics()
        setUpScenery()
        //animateCrocodile()
        setUpPrize()
        setUpVines()
        setUpCrocodile()
        //setUpAudio()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    //MARK: - Level setup
    
    fileprivate func setUpPhysics() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        physicsWorld.speed = 1.0
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
    }
    
    fileprivate func setUpPrize() {
        prize = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.Prize))
        prize.position = CGPoint(x: size.width*0.5, y: size.height*0.7)
        prize.zPosition = Layer.Prize
        prize.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: ImageName.Prize), size: prize.size)
        prize.physicsBody?.categoryBitMask = PhysicsCategory.Prize
        prize.physicsBody?.collisionBitMask = 0
        prize.physicsBody?.density = 0.5
        prize.physicsBody?.isDynamic = true
        addChild(prize)
    }
    
    //MARK: - Vine methods
    
    fileprivate func setUpVines() {
        // 1 load vine data
        let dataFile = Bundle.main.path(forResource: GameConfiguration.VineDataFile, ofType: nil)
        let vines = NSArray(contentsOfFile: dataFile!) as! [NSDictionary]
        
        // 2 add vines
        for i in 0 ..< vines.count{
        // 3 create vine
        let vineData = vines[i]
        let length = Int(vineData["length"] as! NSNumber)
        let relAnchorPoint = CGPointFromString(vineData["relAnchorPoint"] as! String)
        let anchorPoint = CGPoint(x: relAnchorPoint.x * size.width,
                                  y: relAnchorPoint.y * size.height)
        let vine = VineNode(length: length, anchorPoint: anchorPoint, name: "\(i)")
        
        // 4 add to scene
        vine.addToScene(self)
        
        // 5 connect the other end of the vine to the prize
        vine.attachToPrize(prize)
        }
    }
    
    //MARK: - Croc methods
    
    fileprivate func setUpCrocodile() {
        
        crocodile = SKSpriteNode(texture: SKTexture(imageNamed: ImageName.CrocMouthClosed))
        crocodile.position = CGPoint(x: size.width*0.75, y: size.height*0.312)
        crocodile.zPosition = Layer.Crocodile

        crocodile.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: ImageName.CrocMask), size: crocodile.size)
        
        crocodile.physicsBody?.categoryBitMask = PhysicsCategory.Crocodile
        crocodile.physicsBody?.collisionBitMask = 0
        crocodile.physicsBody?.contactTestBitMask = PhysicsCategory.Prize
        
        crocodile.physicsBody?.isDynamic = false
        
        
        addChild(crocodile)
        
        animateCrocodile()
    }
    
    fileprivate func animateCrocodile() {
        //mutipy by the difference then add on the minimum number
        
        //Generate a random number in range 2 to 3, by using drand48() which generate a random double in range 0 to 1. Store result in duration
        let d = drand48()
        var duration = (d + 2)
        
        let waitOpen = SKAction.wait(forDuration: duration)
        let open = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthOpen))
        //Generate a random number in range 3 to 5, by using drand48() which generate a random double in range 0 to 1. Store result in duration.
        let r = drand48()
        duration = ((r * 3) + 2)
        let waitClosed = SKAction.wait(forDuration: duration)
        let close = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthClosed))
        
        let sequence = SKAction.sequence([waitOpen, open, waitClosed, close])
        let loop = SKAction.repeatForever(sequence)
        
        crocodile.run(loop)
        
        
    }
    
    fileprivate func runNomNomAnimationWithDelay(_ delay: TimeInterval) { }
    
    //MARK: - Touch handling
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    fileprivate func showMoveParticles(touchPosition: CGPoint) { }
    
    //MARK: - Game logic
    
    override func update(_ currentTime: TimeInterval) { }
    func didBegin(_ contact: SKPhysicsContact) { }
    fileprivate func checkIfVineCutWithBody(_ body: SKPhysicsBody) { }
    fileprivate func switchToNewGameWithTransition(_ transition: SKTransition) { }
    
    //MARK: - Audio
    
    fileprivate func setUpAudio() { }
}
