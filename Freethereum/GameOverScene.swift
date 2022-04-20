//
//  GameOverScene.swift
//  Freethereum
//
//  Created by HPro2 on 3/7/22.
//

import UIKit
import SpriteKit



class GameOverScene: SKScene {
    var gameOver: SKLabelNode!
    var playAgain: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "gameOver")
        
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameOver = SKLabelNode(fontNamed: "Bodoni 72 Oldstyle Bold")
        gameOver.text = "Game Over"
        gameOver.position = CGPoint(x: 520, y: 550)
        gameOver.horizontalAlignmentMode = .center
        gameOver.fontSize = 60
        gameOver.fontColor = .green
        addChild(gameOver)
        
        playAgain = SKLabelNode(fontNamed: "Bradley Hand Bold")
        playAgain.text = "Tap Anywhere to Play Again!"
        playAgain.position = CGPoint(x: 535, y: 370)
        playAgain.horizontalAlignmentMode = .center
        playAgain.fontSize = 40
        playAgain.fontColor = .white
        addChild(playAgain)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = GameScene(fileNamed: "GameScene")!
        let transition = SKTransition.crossFade(withDuration: 1)
        self.view?.presentScene(scene, transition: transition)
    }
}
