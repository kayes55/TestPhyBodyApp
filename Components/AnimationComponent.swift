//
//  AnimationComponent.swift
//  TestPhyBodyApp
//
//  Created by Imrul Kayes on 1/29/18.
//  Copyright © 2018 Imrul Kayes. All rights reserved.
//

import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
    let spriteComponent: SpriteComponent
    var textures: Array<SKTexture> = []
    
    init(entity: GKEntity, textures: Array<SKTexture>) {
        self.textures = textures
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func startAnimation() {
        print("Animation has started")
        if !spriteComponent.node.hasActions() {
            let playerAnimation = SKAction.animate(with: textures, timePerFrame: 0.07)
            spriteComponent.node.run(SKAction.repeatForever(playerAnimation))
        }
    }
    
    func stopAnimation() {
        spriteComponent.node.removeAllActions()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if movementAllowed {
            startAnimation()
        } else {
            stopAnimation()
        }
    }
}
