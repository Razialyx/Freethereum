//
//  TapArea.swift
//  Freethereum
//
//  Created by HPro2 on 2/23/22.
//

import SpriteKit

class TapArea: SKNode {
    
    var characterNode: SKSpriteNode!
    var isVisible = false
    var isTapped = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
//        let placeholder = SKSpriteNode(color: UIColor.red, size: CGSize(width: 50, height: 3))
//        addChild(placeholder)
        
//        let hole = SKSpriteNode(imageNamed: "hole")
//        addChild(hole)
        
        let mask = SKCropNode()
        mask.maskNode = SKSpriteNode(imageNamed: "mask1")
        mask.position = CGPoint(x: 0, y: 20)
        
        characterNode = SKSpriteNode(imageNamed: "goodNFT")
        characterNode.position = CGPoint(x: 0, y: -120)
        characterNode.name = "Character"
        mask.addChild(characterNode)
        addChild(mask)
    }
    
    func show(hideTime: Double) {
        if isVisible {
            return
        }
        characterNode.xScale = 1
        characterNode.yScale = 1
        characterNode.position.y = -120
        if Int.random(in: 0...3) == 0 {
            characterNode.texture = SKTexture(imageNamed: "badNFT")
            characterNode.name = "tap"
        } else {
            characterNode.texture = SKTexture(imageNamed: "goodNFT")
            characterNode.name = "noTap"
        }
        characterNode.run(SKAction.moveBy(x: 0, y: 70, duration: 0.4))
        isVisible = true
        isTapped = false
        DispatchQueue.main.asyncAfter(deadline: .now() + hideTime * 4) {[weak self] in
            self?.hide()
            
        }
    }
    
    func hide() {
        if !isVisible {
            return
        }
        characterNode.run(SKAction.moveBy(x: 0, y: -70, duration: 0.4))
        isVisible = false
    }
    
    func tap(hideSpeed: Double) {
        isTapped = true
        // personal choice for immediate action: Change image, size, add anim
        let splashed = SKAction.run { [weak self] in
            if hideSpeed == 0.5 {
                if let bokeh = SKEmitterNode(fileNamed: "Bokeh") {
                    bokeh.position.y -= 35
                    self?.addChild(bokeh)
                    
                }
            } else {
                if let magic = SKEmitterNode(fileNamed: "Magic") {
                    magic.position.y -= 35
                    self?.addChild(magic)
                }
            }
        }
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -70, duration: hideSpeed)
        let notVisible = SKAction.run { [weak self] in
            self?.isVisible = false
        }
        characterNode.run(SKAction.sequence([splashed, delay, hide, notVisible]))
        
    }
}

