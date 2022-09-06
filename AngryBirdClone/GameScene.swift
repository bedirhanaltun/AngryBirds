//
//  GameScene.swift
//  AngryBirdClone
//
//  Created by Bedirhan Altun on 6.09.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var brick1 = SKSpriteNode()
    var brick2 = SKSpriteNode()
    var brick3 = SKSpriteNode()
    var brick4 = SKSpriteNode()
    var brick5 = SKSpriteNode()
    
    var gameStarted = false
    
    var originalPosition: CGPoint?
    var originalPositionBrick1: CGPoint?
    var originalPositionBrick2: CGPoint?
    var originalPositionBrick3: CGPoint?
    var originalPositionBrick4: CGPoint?
    var originalPositionBrick5: CGPoint?
    
    var score = 0
    var scoreLabel = SKLabelNode()
    
    enum ColliderType: UInt32{
        //Mesela aşağıda case Tree değerim olsaydı 3 veremezdim çünkü Bird ve Brickin değerleri toplamı aşağıdaki değeri veremez.
        
        case Bird = 1
        case Brick = 2
    }
    
    
    override func didMove(to view: SKView) {
        
        /*
         let texture = SKTexture(imageNamed: "background")
         bird = SKSpriteNode(texture: texture)
         bird.position = CGPoint(x: -self.frame.width / 4, y: -self.frame.height / 4)
         bird.size = CGSize(width: self.frame.width , height: self.frame.height)
         bird.zPosition = 1
         self.addChild(bird)
         */
        
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.scene?.scaleMode = .aspectFit
        self.physicsWorld.contactDelegate = self
        
        brickSettings()
        
        birdSettings()
        
        scoreLabelSettings()
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted == false{
            
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false{
                    
                    for node in touchNodes{
                        
                        if let sprite = node as? SKSpriteNode{
                            
                            if sprite == bird {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
            
            
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false{
                    
                    for node in touchNodes{
                        
                        if let sprite = node as? SKSpriteNode{
                            
                            if sprite == bird {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
            
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false{
                    
                    for node in touchNodes{
                        
                        if let sprite = node as? SKSpriteNode{
                            
                            if sprite == bird {
                                let dX  = -(touchLocation.x - originalPosition!.x)
                                let dY = -(touchLocation.y - originalPosition!.y)
                                
                                let impulse = CGVector(dx: dX, dy: dY)
                                bird.physicsBody?.applyImpulse(impulse)
                                bird.physicsBody?.affectedByGravity = true
                                gameStarted = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.collisionBitMask == ColliderType.Bird.rawValue || contact.bodyB.collisionBitMask == ColliderType.Bird.rawValue{
            score += 1
            scoreLabel.text = String(score)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    //Devamlı kontrol etmek istediğim koşulları burada yazıyorum.
    
    override func update(_ currentTime: TimeInterval) {
        
        if let birdBody = bird.physicsBody {
            //AngularVelocity --> Açısal Hız
            if birdBody.velocity.dx <= 0.3 && birdBody.velocity.dy <= 0.3 && birdBody.angularVelocity <= 0.3 && gameStarted == true {
                
                bird.physicsBody?.affectedByGravity = false
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.angularVelocity = 0
                bird.zPosition = 1
                bird.position = originalPosition!
                brick1.position = originalPositionBrick1!
                brick2.position = originalPositionBrick2!
                brick3.position = originalPositionBrick3!
                brick4.position = originalPositionBrick4!
                brick5.position = originalPositionBrick5!
                gameStarted = false
                scoreLabel.text = "0"
            }
        }
        
    }
    
    func scoreLabelSettings(){
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height / 3)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
    }
    
    
    func birdSettings(){
        bird = childNode(withName: "bird") as! SKSpriteNode
        
        let birdTexture = SKTexture(imageNamed: "bird")
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 13)
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.mass = 0.15
        originalPosition = bird.position
        
        bird.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        
        //collisionBitMask'e Bird dersek kuş kendi çarpışmalarını da sayar.
        bird.physicsBody?.collisionBitMask = ColliderType.Brick.rawValue
    }
    
    func brickSettings(){
        let brickTexture = SKTexture(imageNamed: "brick")
        let brickSize = CGSize(width: brickTexture.size().width / 6, height: brickTexture.size().height / 6)
        
        brick1 = childNode(withName: "brick1") as! SKSpriteNode
        brick1.physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        brick1.physicsBody?.isDynamic = true
        brick1.physicsBody?.affectedByGravity = true
        //Kutu sağa sola dönebilir mi --> allowsRotation
        brick1.physicsBody?.allowsRotation = true
        brick1.physicsBody?.mass = 0.4
        brick1.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        originalPositionBrick1 = brick1.position
        
        brick2 = childNode(withName: "brick2") as! SKSpriteNode
        brick2.physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        brick2.physicsBody?.isDynamic = true
        brick2.physicsBody?.affectedByGravity = true
        //Kutu sağa sola dönebilir mi --> allowsRotation
        brick2.physicsBody?.allowsRotation = true
        brick2.physicsBody?.mass = 0.4
        brick2.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        originalPositionBrick2 = brick2.position
        
        brick3 = childNode(withName: "brick3") as! SKSpriteNode
        brick3.physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        brick3.physicsBody?.isDynamic = true
        brick3.physicsBody?.affectedByGravity = true
        //Kutu sağa sola dönebilir mi --> allowsRotation
        brick3.physicsBody?.allowsRotation = true
        brick3.physicsBody?.mass = 0.4
        brick3.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        originalPositionBrick3 = brick3.position
        
        brick4 = childNode(withName: "brick4") as! SKSpriteNode
        brick4.physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        brick4.physicsBody?.isDynamic = true
        brick4.physicsBody?.affectedByGravity = true
        //Kutu sağa sola dönebilir mi --> allowsRotation
        brick4.physicsBody?.allowsRotation = true
        brick4.physicsBody?.mass = 0.4
        brick4.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        originalPositionBrick4 = brick4.position
        
        brick5 = childNode(withName: "brick5") as! SKSpriteNode
        brick5.physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        brick5.physicsBody?.isDynamic = true
        brick5.physicsBody?.affectedByGravity = true
        //Kutu sağa sola dönebilir mi --> allowsRotation
        brick5.physicsBody?.allowsRotation = true
        brick5.physicsBody?.mass = 0.4
        brick5.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        originalPositionBrick5 = brick5.position
    }
}
