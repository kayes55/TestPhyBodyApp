//
//  GameScene.swift
//  TestPhyBodyApp
//
//  Created by Imrul Kayes on 1/14/18.
//  Copyright © 2018 Imrul Kayes. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import UIKit

//

struct PhysicsCategory {
    static let None: UInt32 =       0       //0
    static let Player: UInt32 =     0b1     //1
    static let Obstacle: UInt32 =   0b10    //2
    static let Ground: UInt32 =     0b100   //4
}

//

var hitTop = false
var playing = false
var movementAllowed = false

//protocol

protocol GameSceneDelegate {
    //func screenshot()
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    var playableStart: CGFloat = 0
    var playableHeight: CGFloat = 0
    var margin: CGFloat = 30.0
    
    let worldNode = SKNode()
    var scoreLabel: SKLabelNode!
    var score = 0
    var fontName = "AmericanTypewriter-Bold"
    
    let numberOfBackgrounds = 2
    let numberOfForegrounds = 2
    
    // Video 12 variables, with 5 errors
    let bottomObstacleMinFraction: CGFloat = 0.1
    let bottomObstacleMaxFraction: CGFloat = 0.6
    
    let firstSpawnDilay: TimeInterval = 2.25
    let everySpawnDelay: TimeInterval = 4.1
    
    // video 12 variables ends here
    
    let groundSpeed:CGFloat = 100.0
    let backgroundSpeed1:CGFloat = 4.0
    let backgroundSpeed2:CGFloat = 10.0
    
    
    //Add Player
    let player = Player(imageName: "fatJimmy0.png")
    let popAction = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    let coinSound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
            MainMenuState(scene: self),
            InstructionsState(scene: self),
            PlayingState(scene: self),
            FallingState(scene: self),
            GameOverState(scene: self)
        ])
    
    var initialState: AnyClass
    var gameSceneDelegate: GameSceneDelegate
    
    //I have to put this init method, but why???
    init(size: CGSize, stateClass: AnyClass, delegate: GameSceneDelegate) {
        
        gameSceneDelegate = delegate
        initialState = stateClass
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0.0)
        physicsWorld.contactDelegate = self
        addChild(worldNode)
        
//        setupBackground()
//        setupForeground()
//        setupPlayer()
//        setupScoreLabel()
        
        gameState.enter(initialState)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            
            
            switch gameState.currentState {
            case is MainMenuState:
                print("Main Menu Scene")
                if touchLocation.x < size.width * 0.6 && touchLocation.y > size.height * 0.55 && touchLocation.y < size.height * 0.65 {
                    restartGame(InstructionsState.self)
                }
            case is InstructionsState:
                if touchLocation.y > playableStart {
                    print("Enter Playing State")
                    gameState.enter(PlayingState.self)
                }
            case is PlayingState:
                print("Playing State: \(String(describing: player.movementComponent))")
                player.movementComponent?.applyImpulse(lastUpdateTimeInterval)
            case is GameOverState:
                if touchLocation.x < size.width * 0.6 && touchLocation.y > size.height * 0.38 && touchLocation.y < size.height * 0.48 {
                    restartGame(InstructionsState.self)
                }
            default:
                break
            }
        }
        
    }
    
    func restartGame(_ stateClass: AnyClass) {
        print("Game Restarts")
        run(popAction)
        
        let newScene = GameScene(size: size, stateClass: stateClass, delegate: gameSceneDelegate)
        let transition = SKTransition.fade(with: SKColor.black, duration: 0.1)
        view?.presentScene(newScene, transition: transition)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == PhysicsCategory.Ground {
            print("Hit The ground")
            gameState.enter(GameOverState.self)
        }
        if other.categoryBitMask == PhysicsCategory.Obstacle {
            print("Hit Obstacles")
            gameState.enter(FallingState.self)
            print("Enter FallingState")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
//        updateBackground()
//        updateForeground()
        
        gameState.update(deltaTime: deltaTime)
        
        player.update(deltaTime: deltaTime)
        
        if hitTop == true {
            gameState.enter(FallingState.self)
        }
    }
    
    func initialJimmyScaleUp() {
        print("Initial Jimmy Called Here")
        self.player.spriteComponent?.node.run(SKAction.scale(to: 1.2, duration: 0.5))
        player.spriteComponent?.node.run(SKAction.rotate(toAngle: 3.1459 * 2.0, duration: 0.6))
    }
    
    func setupBackground() {
        let background1 = SKSpriteNode(imageNamed: "Background1")
        /*let background1 = SKSpriteNode(imageNamed: "Background1")
        background1.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        background1.position = CGPoint(x: size.width / 2, y: size.height)
        background1.zPosition = -10
        worldNode.addChild(background1)
        */
        
        for i in 0..<numberOfBackgrounds {
            let background1 = SKSpriteNode(imageNamed: "Background1")
            background1.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            background1.position = CGPoint(x: CGFloat(i) * size.width, y: size.height)
            background1.zPosition = -10
            background1.name = "background1"
            worldNode.addChild(background1)
        }
        
        for i in 0..<numberOfBackgrounds {
            let background2 = SKSpriteNode(imageNamed: "Background2")
            background2.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            background2.position = CGPoint(x: CGFloat(i) * size.width, y: size.height)
            background2.zPosition = -9
            background2.name = "background2"
            worldNode.addChild(background2)
        }
        
        
        //Helps create the physics body so it stops where the foreground begins.
        playableStart = size.height - background1.size.height
        playableHeight = background1.size.height
        let lowerLeft = CGPoint(x: 0, y: playableStart)
        let lowerRight = CGPoint(x: size.width, y: playableStart)
        
        //Add physics body for ground
        physicsBody = SKPhysicsBody(edgeFrom: lowerLeft, to: lowerRight)
        physicsBody?.categoryBitMask = PhysicsCategory.Ground
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.Player
        
    }
    
    func updateBackground(){
        
        worldNode.enumerateChildNodes(withName: "background1") { (node, stop) in
            
            if let background1 = node as? SKSpriteNode {
                let moveAmount = CGPoint(x: -self.backgroundSpeed1 * CGFloat(self.deltaTime), y: 0)
                background1.position += moveAmount
                
                if background1.position.x < -background1.size.width {
                    background1.position += CGPoint(x: background1.size.width * CGFloat(self.numberOfBackgrounds), y: 0)
                }
            }
        }
        
        worldNode.enumerateChildNodes(withName: "background2") { (node, stop) in
            
            if let background2 = node as? SKSpriteNode {
                let moveAmount = CGPoint(x: -self.backgroundSpeed2 * CGFloat(self.deltaTime), y: 0)
                background2.position += moveAmount
                
                if background2.position.x < -background2.size.width {
                    background2.position += CGPoint(x: background2.size.width * CGFloat(self.numberOfBackgrounds), y: 0)
                }
            }
        }
    }
    
    func updateForeground(){
        
        worldNode.enumerateChildNodes(withName: "foreground") { (node, stop) in
            
            if let foreground = node as? SKSpriteNode {
                let moveAmount = CGPoint(x: -self.groundSpeed * CGFloat(self.deltaTime), y: 0)
                foreground.position += moveAmount
                
                if foreground.position.x < -foreground.size.width {
                    foreground.position += CGPoint(x: foreground.size.width * CGFloat(self.numberOfForegrounds), y: 0)
                }
            }
        }
        
        
        
    }
    
    func setupForeground(){
        print("setting up foreground")
        for i in 0..<numberOfForegrounds {
            let foreground = SKSpriteNode(imageNamed: "Ground.png")
            foreground.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            foreground.position = CGPoint(x: CGFloat(i) * size.width, y: playableStart)
            foreground.zPosition = -5
            foreground.name = "foreground"
            worldNode.addChild(foreground)
        }
        
        player.movementComponent?.playableStart = playableStart
    }
    
    func setupPlayer(){
        let playerNode = player.spriteComponent?.node
        player.movementComponent?.playableHeight = playableHeight + playableStart
        playerNode?.position = CGPoint(x: size.width * 0.2, y: playableStart + (playerNode?.size.height)! / 2)
        playerNode?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playerNode?.setScale(0.75)
        playerNode?.zPosition = 10
        
        worldNode.addChild(playerNode!)
    }
    
    func setupScoreLabel(){
        scoreLabel = SKLabelNode(fontNamed: fontName)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - margin)
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.zPosition = 11
        
        scoreLabel.text = "\(score)"
        worldNode.addChild(scoreLabel)
    }
    
    
    func createObstacle() -> SKSpriteNode {
        let obstacle = Obstacle(imageName: "carrot.png")
        let obstacleNode = obstacle.spriteComponent.node
        obstacleNode.zPosition = -6
        
        obstacleNode.name = "obstacle"
        obstacleNode.userData = NSMutableDictionary()
        
        return obstacleNode
    }
    
    func spawnObstacle() {
        
        let bottomObstacle = createObstacle()
        let startX = size.width + bottomObstacle.size.width / 2
        
        let bottomObstacleMin = (playableStart - bottomObstacle.size.height / 2) + playableHeight * bottomObstacleMinFraction
        let bottomObstacleMax = (playableStart - bottomObstacle.size.height / 2) + playableHeight * bottomObstacleMaxFraction
        
        
        let randomSource = GKARC4RandomSource()
        let randomDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: Int(round(bottomObstacleMin)), highestValue: Int(round(bottomObstacleMax)))
        let randomValue = randomDistribution.nextInt()
        
        bottomObstacle.position = CGPoint(x: startX, y: CGFloat(randomValue))
        worldNode.addChild(bottomObstacle)
        
        let moveX = size.width + bottomObstacle.size.width
        let moveDuration = moveX / groundSpeed
        
        let sequence = SKAction.sequence([SKAction.moveBy(x: -moveX, y: 0, duration: TimeInterval(moveDuration)), SKAction.removeFromParent()])
        bottomObstacle.run(sequence)
        
    }
    
    func startSpawningObstacle() {
        
        let firstDelay = SKAction.wait(forDuration: firstSpawnDilay)
        let spawn = SKAction.run(spawnObstacle)
        let everyDelay = SKAction.wait(forDuration: everySpawnDelay)
        
        let spawnSequence = SKAction.sequence([spawn, everyDelay])
        let foreverSpawn = SKAction.repeatForever(spawnSequence)
        let overallSequence = SKAction.sequence([firstDelay, foreverSpawn])
        
        run(overallSequence, withKey: "spawn")
        
    }
    
    func stopSpawningObstacle() {
        
        removeAction(forKey: "spawn")
        worldNode.enumerateChildNodes(withName: "obstacle") { (node, stop) in
            
            node.removeAllActions()
            
        }
        
    }
    
    func updateScoreLabel() {
        worldNode.enumerateChildNodes(withName: "obstacle") { (node, stop) in
            
            if let obstacle = node as? SKSpriteNode {
                if let passed = obstacle.userData?["Passed"] as? NSNumber {
                    if passed.boolValue {
                        return
                    }
                }
                
                if (self.player.spriteComponent?.node.position.x)! > obstacle.position.x + obstacle.size.width / 2 {
                    self.score = self.score + 10
                    self.scoreLabel.text = "\(self.score / 1)"
                    
                    obstacle.userData?["Passed"] = NSNumber(value: true)
                    self.run(self.coinSound)
                    
                    let scaleUp = SKAction.scale(to: 1.5, duration: 0.05)
                    let scaleDown = SKAction.scale(to: 1.0, duration: 0.05)
                    let sequence = SKAction.sequence([scaleUp, scaleDown])
                    
                    self.scoreLabel.fontColor = SKColor.purple
                    self.scoreLabel.run(sequence)
                    
                    let wait = SKAction.wait(forDuration: 0.1)
                    let returnToWhite = SKAction.run({
                        self.scoreLabel.fontColor = SKColor.white
                    })
                    
                    let sequence2 = SKAction.sequence([wait, returnToWhite])
                    self.scoreLabel.run(sequence2)
                }
            }
            
        }
    }
    
    
}
