import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background: SKSpriteNode!
    var water: SKSpriteNode!
    private var crocodile: SKSpriteNode!
    private var prize: SKSpriteNode!
    private static var backgroundMusicPlayer: AVAudioPlayer!
    private var sliceSoundAction: SKAction!
    private var splashSoundAction: SKAction!
    private var nomNomSoundAction: SKAction!
    private var levelOver = false
    private var vineCut = false
    
    let margin = CGFloat(30)
    
    var pauseButton: ButtonNode!
    var resumeButton: ButtonNode!
    var optionsButton: ButtonNode!
    var exitButton: ButtonNode!
    var backButton: ButtonNode!
    
    override func didMove(to view: SKView) {
        setUpPhysics()
        setUpScenery()
        setUpPrize()
        setUpVines()
        setUpCrocodile()
        setUpAudio()
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

        //HUD.ButtonPause.size = CGSize(width: self.size.width, height: self.size.height)
        
        // MARK: Add pause menu button
        pauseButton = ButtonNode(iconName: HUD.ButtonPause, text: String(""), onButtonPress: pauseButtonPressed)
        pauseButton.position = CGPoint(x: -size.width * 0.03, y: pauseButton.size.height / 2)
        addChild(pauseButton)
        
        // MARK: Add resume pause menu button
        resumeButton = ButtonNode(iconName: ImageName.Clear , text: String("Resume"), onButtonPress: resumeButtonPressed)
        resumeButton.position = CGPoint(x: size.width * 0.50, y: size.height * 0.60 + resumeButton.size.height / 2)
        resumeButton.zPosition = Layer.Button
        //resumeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        addChild(resumeButton)
        
        // MARK: Add options pause menu button
        optionsButton = ButtonNode(iconName: ImageName.Clear, text: String("Options"), onButtonPress: optionsButtonPressed)
        optionsButton.position = CGPoint(x: size.width * 0.50, y: size.height * 0.50 + optionsButton.size.height / 2)
        optionsButton.zPosition = Layer.Button
        addChild(optionsButton)
        
        // MARK: Add exit pause menu button
        exitButton = ButtonNode(iconName: ImageName.Clear, text: String("Exit"), onButtonPress: exitButtonPressed)
        exitButton.position = CGPoint(x: size.width * 0.50, y: size.height * 0.40 + exitButton.size.height / 2)
        exitButton.zPosition = Layer.Button
        addChild(exitButton)
        
        // MARK: Add back pause menu button
        backButton = ButtonNode(iconName: ImageName.Clear, text: String("Back"), onButtonPress: backButtonPressed)
        backButton.position = CGPoint(x: size.width * 0.50, y: size.height * 0.40 + backButton.size.height / 2)
        backButton.zPosition = Layer.Button
        addChild(backButton)
        
        resumeButton.isHidden = true;
        optionsButton.isHidden = true;
        exitButton.isHidden = true;
        backButton.isHidden = true;
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
            let length = Int(truncating: vineData["length"] as! NSNumber)
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
    
    fileprivate func runNomNomAnimationWithDelay(_ delay: TimeInterval) {
        crocodile.removeAllActions()
        
        let closeMouth = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthClosed))
        let wait = SKAction.wait(forDuration: delay)
        let openMouth = SKAction.setTexture(SKTexture(imageNamed: ImageName.CrocMouthOpen))
        let sequence = SKAction.sequence([closeMouth, wait, openMouth, wait, closeMouth])
        
        crocodile.run(sequence)
    }
    
    //MARK: - Touch handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        vineCut = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let startPoint = touch.location(in: self)
            let endPoint = touch.previousLocation(in: self)
            
            // check if vine cut
            scene?.physicsWorld.enumerateBodies(alongRayStart: startPoint, end: endPoint,
                                                using: { (body, point, normal, stop) in
                                                    self.checkIfVineCutWithBody(body)
                                                    
            })
            
            // produce some nice particles
            showMoveParticles(touchPosition: startPoint)
            crocodile.removeAllActions()
            crocodile.texture = SKTexture(imageNamed: ImageName.CrocMouthOpen)
            animateCrocodile()
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    fileprivate func showMoveParticles(touchPosition: CGPoint) { }
    
    //MARK: - Game logic
    
    override func update(_ currentTime: TimeInterval) {
        if levelOver {
            return
        }
        if prize.position.y <= 0 {
            levelOver = true
            run(splashSoundAction)
            switchToNewGameWithTransition(SKTransition.fade(withDuration: 1.0))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if levelOver {
            return
        }
        if (contact.bodyA.node == crocodile && contact.bodyB.node == prize)
            || (contact.bodyA.node == prize && contact.bodyB.node == crocodile) {
            levelOver = true
            
            // shrink the pineapple away
            let shrink = SKAction.scale(to: 0, duration: 0.08)
            let removeNode = SKAction.removeFromParent()
            let sequence = SKAction.sequence([shrink, removeNode])
            runNomNomAnimationWithDelay(0.15)
            run(nomNomSoundAction)
            // transition to next level
            switchToNewGameWithTransition(SKTransition.doorway(withDuration: 1.0))
            prize.run(sequence)
        }
    }
    
    fileprivate func checkIfVineCutWithBody(_ body: SKPhysicsBody) {
        
        if vineCut && !GameConfiguration.CanCutMultipleVinesAtOnce {
            return
        }
        
        let node = body.node!
        
        // if it has a name it must be a vine node
        if let name = node.name {
            
            // snip the vine
            node.removeFromParent()
            
            // fade out all nodes matching name
            enumerateChildNodes(withName: name, using: { (node, stop) in
                let fadeAway = SKAction.fadeOut(withDuration: 0.25)
                let removeNode = SKAction.removeFromParent()
                let sequence = SKAction.sequence([fadeAway, removeNode])
                node.run(sequence)
            })
            run(sliceSoundAction)
        }
        vineCut = true
    }
    
    fileprivate func switchToNewGameWithTransition(_ transition: SKTransition) {
        let delay = SKAction.wait(forDuration: 0)
        let sceneChange = SKAction.run({
            let scene = GameScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
        })
        
        run(SKAction.sequence([delay, sceneChange]))
    }
    
    fileprivate func switchToMainMenu(_ transition: SKTransition) {
        let delay = SKAction.wait(forDuration: 0)
        let sceneChange = SKAction.run({
            let scene = MenuScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
        })
        
        run(SKAction.sequence([delay, sceneChange]))
    }
    
    //MARK: - Audio
    
    fileprivate func setUpAudio() {
        if GameScene.backgroundMusicPlayer == nil {
            let backgroundMusicURL = Bundle.main.url(forResource: SoundFile.BackgroundMusic, withExtension: nil)
            
            do {
                let theme = try AVAudioPlayer(contentsOf: backgroundMusicURL!)
                GameScene.backgroundMusicPlayer = theme
                
            } catch {
                // couldn't load file :[
            }
            
            GameScene.backgroundMusicPlayer.numberOfLoops = -1
        }
        if !GameScene.backgroundMusicPlayer.isPlaying {
            GameScene.backgroundMusicPlayer.play()
        }
        
        sliceSoundAction = SKAction.playSoundFileNamed(SoundFile.Slice, waitForCompletion: false)
        splashSoundAction = SKAction.playSoundFileNamed(SoundFile.Splash, waitForCompletion: false)
        nomNomSoundAction = SKAction.playSoundFileNamed(SoundFile.NomNom, waitForCompletion: false)
    }
    
    var unchecked = true
    
    @IBAction func tick(sender: UIButton) {
        if unchecked {
            sender.setImage(UIImage(named: "checked.png"), for: [])
            unchecked = false
        }
        else {
            sender.setImage( UIImage(named:"unchecked.png"), for: [])
            unchecked = true
        }
    }
    
    func pauseButtonPressed() {
        print("Pause button pressed!")
        pauseButton.isHidden = true;
        self.isPaused = true
        resumeButton.isHidden = false;
        optionsButton.isHidden = false;
        exitButton.isHidden = false;
        //self.physicsWorld.speed = 0.0
    }
    
    func resumeButtonPressed() {
        print("Resume button pressed!")
        pauseButton.isHidden = false;
        resumeButton.isHidden = true;
        optionsButton.isHidden = true;
        exitButton.isHidden = true;
        self.isPaused = false
    }
    
    func optionsButtonPressed() {
        print("Options button pressed!")
        resumeButton.isHidden = true;
        optionsButton.isHidden = true;
        exitButton.isHidden = true;
        backButton.isHidden = false;
    }
    
    func exitButtonPressed() {
        print("Exit button pressed!")
        self.isPaused = false
        switchToMainMenu(SKTransition.fade(withDuration: 0))
    }
    
    func backButtonPressed() {
        print("Exit button pressed!")
        resumeButton.isHidden = false;
        optionsButton.isHidden = false;
        exitButton.isHidden = false;
        backButton.isHidden = true;
        
    }
    
}
