//
//  PlayingState.swift
//  TestPhyBodyApp
//
//  Created by Imrul Kayes on 1/29/18.
//  Copyright © 2018 Imrul Kayes. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayingState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Enter into PlayingState")
        
        hitTop = false
        playing = true
        movementAllowed = true
        
        if previousState is InstructionsState {
            scene.initialJimmyScaleUp()
        }
        
        scene.startSpawningObstacle()
        scene.player.animationComponent?.startAnimation()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass is FallingState.Type) || (stateClass is GameOverState.Type)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        scene.updateBackground()
        scene.updateForeground()
        scene.updateScoreLabel()
    }
}
