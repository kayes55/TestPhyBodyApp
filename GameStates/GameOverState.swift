//
//  GameOverState.swift
//  TestPhyBodyApp
//
//  Created by Imrul Kayes on 1/29/18.
//  Copyright © 2018 Imrul Kayes. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    let hitGroundAction = SKAction.playSoundFileNamed("hitGround.wav", waitForCompletion: false)
    let animationDelay = 0.35
    
    override func didEnter(from previousState: GKState?) {
        print("Enter GameOverState")
        
        playing = false
        movementAllowed = false
        
        scene.run(hitGroundAction)
        scene.stopSpawningObstacle()
        
        showScoreCard()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return stateClass is PlayingState.Type
    }
    
    func showScoreCard() {
        
        let scorecard = SKSpriteNode(imageNamed: "Scorecard.png")
        scorecard.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.5)
        scorecard.name = "Tutorial"
        scorecard.zPosition = 11
        scene.worldNode.addChild(scorecard)
        
        let lastScore = SKLabelNode(fontNamed: scene.fontName)
        lastScore.fontColor = SKColor.black
        lastScore.fontSize = 24
        lastScore.position = CGPoint(x: -scorecard.size.width * 0.24, y: scorecard.size.height * 0.01)
        lastScore.zPosition = 11
        lastScore.text = "\(scene.score / 1)"
        scorecard.addChild(lastScore)
        
        let bestScoreLabel = SKLabelNode(fontNamed: scene.fontName)
        bestScoreLabel.fontColor = SKColor.black
        bestScoreLabel.fontSize = 24
        bestScoreLabel.position = CGPoint(x: scorecard.size.width * 0.24, y: scorecard.size.height * 0.01)
        bestScoreLabel.zPosition = 11
        // bestScoreLabel.text = "\(bestScore() / 1)"
        scorecard.addChild(bestScoreLabel)

        let lifetimeScoreLabel = SKLabelNode(fontNamed: scene.fontName)
        lifetimeScoreLabel.fontColor = SKColor.black
        lifetimeScoreLabel.fontSize = 20
        lifetimeScoreLabel.position = CGPoint(x: scorecard.size.width * 0.24, y: -scorecard.size.height * 0.35)
        lifetimeScoreLabel.zPosition = 11
        //lifetimeScoreLabel.text = "\(lifetimeScore)"
        scorecard.addChild(lifetimeScoreLabel)

        let gameOver = SKSpriteNode(imageNamed: "gameOver.png")
        gameOver.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 + scorecard.size.height / 2 + scene.margin + gameOver.size.height / 1) //2
        gameOver.zPosition = 11
        gameOver.setScale(1.3)
        scene.worldNode.addChild(gameOver)

        let okButton = SKSpriteNode(imageNamed: "Button.png")
        okButton.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height * 0.65 - scorecard.size.height / 2 - scene.margin - okButton.size.height / 2)
        okButton.zPosition = 11
        scene.worldNode.addChild(okButton)

        let ok = SKSpriteNode(imageNamed: "OK.png")
        ok.position = CGPoint.zero
        ok.zPosition = 11
        okButton.addChild(ok)

        let shareButton = SKSpriteNode(imageNamed: "Button.png")
        shareButton.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height * 0.65 - scorecard.size.height / 2 - scene.margin - shareButton.size.height / 2)
        shareButton.zPosition = 11
        scene.worldNode.addChild(shareButton)

        let share = SKSpriteNode(imageNamed: "Share.png")
        share.position = CGPoint.zero
        share.zPosition = 11
        shareButton.addChild(share)

        let rateButton2 = SKSpriteNode(imageNamed: "Button.png")
        rateButton2.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height * 0.535 - scorecard.size.height / 2 - scene.margin - rateButton2.size.height / 2)
        rateButton2.zPosition = 10
        scene.worldNode.addChild(rateButton2)

        let rate2 = SKSpriteNode(imageNamed: "Rate.png")
        rate2.position = CGPoint.zero
        rateButton2.zPosition = 15
        rateButton2.addChild(rate2)

        //Juice
        gameOver.setScale(0)
        gameOver.alpha = 0
        let group = SKAction.group([
            SKAction.fadeIn(withDuration: animationDelay),
            SKAction.scale(to: 1.3, duration: animationDelay)
            ])
        group.timingMode = .easeInEaseOut
        gameOver.run(SKAction.sequence([
            SKAction.wait(forDuration: animationDelay),
            group
            ]))

        scorecard.position = CGPoint(x: scene.size.width * 0.5, y: -scorecard.size.height / 2)
        let moveTo = SKAction.move(to: CGPoint(x: scene.size.width / 2, y: scene.size.height * 0.625), duration: animationDelay)
        moveTo.timingMode = .easeInEaseOut
        scorecard.run(SKAction.sequence([
            SKAction.wait(forDuration: animationDelay * 0.2), moveTo]))

        okButton.alpha = 0
        shareButton.alpha = 0
        rateButton2.alpha = 0
        let fadeIn = SKAction.sequence([
            SKAction.wait(forDuration: animationDelay * 3),
            SKAction.fadeIn(withDuration: animationDelay)])
        okButton.run(fadeIn)
        shareButton.run(fadeIn)
        rateButton2.run(fadeIn)

        let pops = SKAction.sequence([
            SKAction.wait(forDuration: animationDelay),
            scene.popAction,
            SKAction.wait(forDuration: animationDelay),
            scene.popAction,
            SKAction.wait(forDuration: animationDelay),scene.popAction])
        scene.run(pops)
        
        }
}
