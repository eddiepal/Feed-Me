import SpriteKit

class VineNode: SKNode {
    
    private let length: Int
    private let anchorPoint: CGPoint
    private var vineSegments: [SKNode] = []
    
    init(length: Int, anchorPoint: CGPoint, name: String) {
        
        self.length = length
        self.anchorPoint = anchorPoint
        
        super.init()
        
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        length = aDecoder.decodeInteger(forKey: "length")
        anchorPoint = aDecoder.decodeCGPoint(forKey: "anchorPoint")
        
        super.init(coder: aDecoder)
    }
    
    func addToScene(_ scene: SKScene) {
        // add vine to scene
        zPosition = Layer.Vine
        scene.addChild(self)
        
        // create vine root
        let vineRoot = SKSpriteNode(imageNamed: ImageName.VineRoot)
        vineRoot.position = anchorPoint
        vineRoot.zPosition = 1
        
        addChild(vineRoot)
        
        vineRoot.physicsBody = SKPhysicsBody(circleOfRadius: vineRoot.size.width / 2)
        vineRoot.physicsBody?.isDynamic = false
        vineRoot.physicsBody?.categoryBitMask = PhysicsCategory.VineRoot
        vineRoot.physicsBody?.collisionBitMask = 0
        
        // add each of the vine parts
        for i in 0 ..< length {
            let vineSegment = SKSpriteNode(imageNamed: ImageName.Vine)
            let offset = vineSegment.size.height * CGFloat(i + 1)
            vineSegment.position = CGPoint(x: anchorPoint.x, y: anchorPoint.y - offset)
            vineSegment.name = name
            
            vineSegments.append(vineSegment)
            addChild(vineSegment)
            
            vineSegment.physicsBody = SKPhysicsBody(rectangleOf: vineSegment.size)
            vineSegment.physicsBody?.categoryBitMask = PhysicsCategory.Vine
            vineSegment.physicsBody?.collisionBitMask = PhysicsCategory.VineRoot
        }
    }
    
    func attachToPrize(_ prize: SKSpriteNode) { }
    
}
