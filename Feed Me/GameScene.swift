import SpriteKit

class GameScene: SKScene {
    
    var background: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        //setUpPhysics()
        setUpScenery()
        //setUpPrize()
        //setUpVines()
        //setUpCrocodile()
        //setUpAudio()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    //MARK: - Level setup
    
    fileprivate func setUpPhysics() { }
    fileprivate func setUpScenery() {
        
        background = SKSpriteNode(imageNamed: ImageName.Background)
    
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = Layer.Background
        background.anchorPoint = CGPoint(x: 0,y: 0)
        background.size = CGSize(width: self.size.width, height: self.size.height)
    
        addChild(background)
    }
    
    
    fileprivate func setUpPrize() { }
    
    //MARK: - Vine methods
    
    fileprivate func setUpVines() { }
    
    //MARK: - Croc methods
    
    fileprivate func setUpCrocodile() { }
    fileprivate func animateCrocodile() { }
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
