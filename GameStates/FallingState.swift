//
//  FallingState.swift
//  TestPhyBodyApp
//
//  Created by Imrul Kayes on 1/29/18.
//  Copyright © 2018 Imrul Kayes. All rights reserved.
//

import SpriteKit
import GameplayKit

class FallingState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    let whackAction = SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false)
    let fallingAction = SKAction.playSoundFileNamed("falling.wav", waitForCompletion: false)
    
    override func didEnter(from previousState: GKState?) {
        print("Enter FallingState")
        
        //screen shake code
        
        scene.stopSpawningObstacle()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return stateClass is GameOverState.Type
    }
}
