//
//  MainMenuState.swift
//  TestPhyBodyApp
//
//  Created by Imrul Kayes on 1/29/18.
//  Copyright © 2018 Imrul Kayes. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Enter MainMenuState")
        
        showMainMenu()
        
        scene.setupBackground()
        scene.setupForeground()
        scene.setupPlayer()
        scene.setupScoreLabel()
        
        movementAllowed = false
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is InstructionsState.Type
    }
    
    func showMainMenu() {
        let logo = SKSpriteNode(imageNamed: "titleLogo.png")
        logo.position = CGPoint(x: scene.size.width / 2, y: scene.size.height * 0.8)
        logo.zPosition = 10
        scene.worldNode.addChild(logo)
        
        let playButton = SKSpriteNode(imageNamed: "Button.png")
        playButton.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height * 0.6)
        playButton.zPosition = 10
        scene.worldNode.addChild(playButton)
        
        let play = SKSpriteNode(imageNamed: "Play.png")
        play.position = CGPoint.zero
        play.zPosition = 10
        playButton.addChild(play)
        
        let rateButton = SKSpriteNode(imageNamed: "Button.png")
        rateButton.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height * 0.6)
        rateButton.zPosition = 10
        scene.worldNode.addChild(rateButton)
        
        let rate = SKSpriteNode(imageNamed: "Rate.png")
        rate.position = CGPoint.zero
        rate.zPosition = 10
        rateButton.addChild(rate)
    }
}
