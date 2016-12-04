//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    let verticalPipeGap = 150.0
    
    var bird:SKSpriteNode!
    var skyColor:SKColor!
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    var moving:SKNode!
    var pipes:SKNode!
    var canStart = Bool()
    var scoreLabelNode:SKLabelNode!
    var score = NSInteger()
    
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    let gravity:CGFloat = CGFloat(DifficultyMode.instance.getGravity())
    let impulsion:CGFloat = CGFloat(DifficultyMode.instance.getImpulsion())
    let speedHero:CGFloat = CGFloat(DifficultyMode.instance.getSpeedHero())
    let interPipe:CGFloat = CGFloat(DifficultyMode.instance.getInterPipe())
    
    var beforeGameView:UIView? = nil
    var afterGameview:UIView? = nil
    var tapTapImageView:UIImageView? = nil;
    var currentScoreLabel:UILabel? = nil;
    var topScoreLabel:UILabel? = nil;
    
    // initialise UIView contents
    func setUIViews(beforeGameView : UIView, afterGameView: UIView) {
        self.beforeGameView = beforeGameView;
        self.afterGameview = afterGameView;
        tapTapImageView = Tools.getImageView(view: beforeGameView, id: "TapTap")
        currentScoreLabel = Tools.getLabel(view: afterGameView, id: "currentScore")
        topScoreLabel = Tools.getLabel(view: afterGameView, id: "topScore")
    }
    
    private func setupPhysics() {
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: self.gravity )
        self.physicsWorld.contactDelegate = self
    }
    
    private func createBackground() {
        
        // GROUND
        let groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = .nearest // shorter form for SKTextureFilteringMode.Nearest
        
        let moveGroundSprite = SKAction.moveBy(x: -groundTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveBy(x: groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
        
        for i in stride(from: 0, through: 2.0 + self.frame.size.width / (groundTexture.size().width * 2.0), by: 1) {
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0)
            sprite.run(moveGroundSpritesForever)
            moving.addChild(sprite)
        }
        
        // create ground physic
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: groundTexture.size().height * 2.0))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)
        
        // SKY
        let skyTexture = SKTexture(imageNamed: "sky")
        skyTexture.filteringMode = .nearest
        
        let moveSkySprite = SKAction.moveBy(x: -skyTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveBy(x: skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatForever(SKAction.sequence([moveSkySprite,resetSkySprite]))
        
        
        for i in stride(from: 0, through: 2.0 + self.frame.size.width / (skyTexture.size().width * 2.0), by: 1) {
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.run(moveSkySpritesForever)
            moving.addChild(sprite)
        }
    }
    
    
    private func createAndConfigurePipe() {
        // create the pipes textures
        pipeTextureUp = SKTexture(imageNamed: "PipeUp")
        pipeTextureUp.filteringMode = .nearest
        pipeTextureDown = SKTexture(imageNamed: "PipeDown")
        pipeTextureDown.filteringMode = .nearest
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveBy(x: -distanceToMove, y:0.0, duration:TimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        // spawn the pipes
        let spawn = SKAction.run({() in self.spawnPipes()})
        let delay = SKAction.wait(forDuration: TimeInterval(self.interPipe))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
        self.run(spawnThenDelayForever)
    }
    
    private func createBird() {
        let birdTexture1 = SKTexture(imageNamed: "bird-1")
        birdTexture1.filteringMode = .nearest
        let birdTexture2 = SKTexture(imageNamed: "bird-2")
        birdTexture2.filteringMode = .nearest
        let birdTexture3 = SKTexture(imageNamed: "bird-3")
        birdTexture3.filteringMode = .nearest
        let birdTexture4 = SKTexture(imageNamed: "bird-4")
        birdTexture4.filteringMode = .nearest
        
        let anim = SKAction.animate(with: [birdTexture1, birdTexture2, birdTexture3, birdTexture4], timePerFrame: 0.2)
        let flap = SKAction.repeatForever(anim)
        
        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(2.0)
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        bird.run(flap)
        
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false
        
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(bird)
    }
    
    override func didMove(to view: SKView) {
        
        //start Scene
        startScene()
        
        
        self.isPaused = true;
        
        // setup physics
        self.setupPhysics()
        
        // setup background color
        skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        moving = SKNode()
        self.addChild(moving)
        pipes = SKNode()
        moving.addChild(pipes)
        
        // background
        self.createBackground();
        
        // pipe
        self.createAndConfigurePipe();
        
        // setup our bird
        self.createBird();
        
        // Initialize label and create a label which holds the score
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.position = CGPoint( x: self.frame.midX, y: 3 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        self.addChild(scoreLabelNode)
        
    }
    
    // Create A pipe and a scoreObject (called in boucle by SKScene)
    func spawnPipes() {
        
        // Define the position of the next obstacle
        let pipePair = SKNode()
        pipePair.position = CGPoint( x: self.frame.size.width + pipeTextureUp.size().width * 2, y: 0 )
        pipePair.zPosition = -10
        
        let height = UInt32( self.frame.size.height / 4)
        let y = Double(arc4random_uniform(height) + height);
        
        //add BOTTOM obstacle
        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPoint(x: 0.0, y: y + Double(pipeDown.size.height) + verticalPipeGap)
        
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        pipeDown.physicsBody?.isDynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeDown)
        
        // add TOP obstacle
        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPoint(x: 0.0, y: y)
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.isDynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeUp)
        
        // ADD contact to up the score
        let contactNode = SKNode()
        contactNode.position = CGPoint( x: pipeDown.size.width + bird.size.width / 2, y: self.frame.midY )
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: pipeUp.size.width, height: self.frame.size.height ))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)
        
        pipePair.run(movePipesAndRemove)
        pipes.addChild(pipePair)
        
    }
    
    // Launch BeforeGame Scene (not the game)
    func startScene() {
        canStart = true
        showBeforeGame(active: true)
        showAfterGame(active: false)
    }
    
    // reset utilities parameters for the game
    func resetGame () {
        self.isPaused = false;
        // Move bird to original position and reset velocity
        bird.position = CGPoint(x: self.frame.size.width / 2.5, y: self.frame.midY)
        bird.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.speed = self.speedHero
        bird.zRotation = 0.0
        
        // Remove all existing pipes
        pipes.removeAllChildren()
        
        // Reset _canStart
        canStart = false
        
        // Reset score
        score = 0
        scoreLabelNode.text = String(score)
        
        // Restart animation
        moving.speed = self.speedHero
        
        // hide menu
        showBeforeGame(active: false)
        showAfterGame(active: false)
    }
    
    
    // Called when a touch is pressed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canStart {
            self.resetGame()
        }
        else if moving.speed > 0  {
            for touch: AnyObject in touches {
                _ = touch.location(in: self)
                
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: self.impulsion))
                
            }
        }
    }
    
    // utilie function : return the bigger number
    func clamp(_ min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if( value > max ) {
            return max
        } else if( value < min ) {
            return min
        } else {
            return value
        }
    }
    
    // Update the rotation of the bird
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        bird.zRotation = self.clamp( -1, max: 0.5, value: bird.physicsBody!.velocity.dy * ( bird.physicsBody!.velocity.dy < 0 ? 0.003 : 0.001 ) )
    }
    
    // Called for every collision
    func didBegin(_ contact: SKPhysicsContact) {
        if moving.speed > 0 {
            if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
                // Bird has contact with score entity
                score += 1
                scoreLabelNode.text = String(score)
                
                // Add a little visual feedback for the score increment
                scoreLabelNode.run(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.1)), SKAction.scale(to: 1.0, duration:TimeInterval(0.1))]))
            } else {
                
                // Bird has contact an obstacle
                moving.speed = 0
                bird.physicsBody?.collisionBitMask = worldCategory
                bird.run(  SKAction.rotate(byAngle: CGFloat(M_PI) * CGFloat(bird.position.y) * 0.01, duration:1), completion:{self.bird.speed = 0 })
                
                
                // Flash background if contact is detected
                self.removeAction(forKey: "flash")
                self.run(SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.run({
                    self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
                    }),SKAction.wait(forDuration: TimeInterval(0.05)), SKAction.run({
                        self.backgroundColor = self.skyColor
                        }), SKAction.wait(forDuration: TimeInterval(0.05))]), count:4), SKAction.run({
                            //action after die : launch score
                            ScoreManager.instance.addScore(mode: DifficultyMode.instance.getCurrent(), score: self.score)
                            self.showAfterGame(active: true)
                            })]), withKey: "flash")
            }
        }
    }
    
    // Launch before start the game
    func showBeforeGame(active: Bool) {
        if (active) {
            beforeGameView?.isHidden = false;
            if (tapTapImageView != nil) {
                tapTapImageView?.startAnimating()
            }
        } else {
            beforeGameView?.isHidden = true;
            if (tapTapImageView != nil) {
                tapTapImageView?.stopAnimating()
            }
        }
    }
    
    // Launch after finished the game
    func showAfterGame(active: Bool) {
        if (active) {
            self.afterGameview?.isHidden = false
            self.currentScoreLabel?.text = String(self.score)
            self.topScoreLabel?.text = String(ScoreManager.instance.getBestScore(mode: DifficultyMode.instance.getCurrent()))
        } else {
            self.afterGameview?.isHidden = true
        }
    }

}
