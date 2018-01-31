//
//  InstructionsState.swift
//  TestPhyBodyApp
//
//  Created by Imrul Kayes on 1/29/18.
//  Copyright © 2018 Imrul Kayes. All rights reserved.
//

import SpriteKit
import GameplayKit

class InstructionsState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Enters InstructinsState")
        
        setupInstructions()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    override func willExit(to nextState: GKState) {
        //remove instructions
        scene.worldNode.enumerateChildNodes(withName: "Instructions") { (node, stop) in
            node.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.6), SKAction.removeFromParent()]))
        }
    }
    
    func setupInstructions() {
        
        scene.setupBackground()
        scene.setupForeground()
        scene.setupPlayer()
        scene.setupScoreLabel()
        
        let instructions = SKSpriteNode(imageNamed: "tapToStart.png")
        instructions.position = CGPoint(x: scene.size.width / 2, y: scene.playableHeight * 0.4 + scene.playableStart)
        instructions.name = "Instructions"
        instructions.zPosition = 10
        scene.worldNode.addChild(instructions)
        
        let ready = SKSpriteNode(imageNamed: "ready.png")
        ready.position = CGPoint(x: scene.size.width / 2, y: scene.playableHeight * 0.7 + scene.playableStart)
        ready.name = "Ready"
        ready.zPosition = 10
        scene.worldNode.addChild(ready)
    }
    
}
