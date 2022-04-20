//
//  GameScene.swift
//  Freethereum
//
//  Created by HPro2 on 2/22/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var tapAreas = [TapArea]()
    var gameScore: SKLabelNode!
    var muteButton: SKSpriteNode!
    var backgroundMusic: SKAudioNode!
    var isMuted = false
    var round = 1
    var popupTime = 0.85
    var newGame = false
    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "AlienCity")
        
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Copperplate Bold")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 760, y: 720)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 42
        gameScore.fontColor = .purple
        addChild(gameScore)
        
        muteButton = SKSpriteNode(imageNamed: "unMuteMusic")
        muteButton.position = CGPoint(x: 50, y: 50)
        muteButton.zPosition = 2
        addChild(muteButton)

        if let musicLocation = Bundle.main.url(forResource: "CityLights", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicLocation)
            backgroundMusic.autoplayLooped = false
            backgroundMusic.run(SKAction.changeVolume(to: Float(0.4), duration: 0))
            addChild(backgroundMusic)
            backgroundMusic.run(SKAction.play())
        }
        
        createTapArea(at: CGPoint(x: 255, y: 465))
        createTapArea(at: CGPoint(x: 395, y: 465))
        createTapArea(at: CGPoint(x: 335, y: 660))
        createTapArea(at: CGPoint(x: 535, y: 643))
        createTapArea(at: CGPoint(x: 690, y: 598))
        createTapArea(at: CGPoint(x: 757, y: 607))
        createTapArea(at: CGPoint(x: 855, y: 579))
        createTapArea(at: CGPoint(x: 930, y: 295))
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.createEnemy()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if newGame {
            self.enumerateChildNodes(withName: "gameOver") { (node, stop) in
                node.removeFromParent()
            }
            self.enumerateChildNodes(withName: "playAgain") { (node, stop) in
                node.removeFromParent()
            }
            restartGame()
        } else {
            if let touch = touches.first {
                let location = touch.location(in: self)
                let tappedNodes = nodes(at: location)
                if tappedNodes.contains(muteButton) {
                    isMuted = !isMuted
                    if isMuted {
                        muteButton.texture = SKTexture(imageNamed: "muteMusic")
                        backgroundMusic.run(SKAction.changeVolume(to: Float(0.0), duration: 0))
                    } else {
                        muteButton.texture = SKTexture(imageNamed: "unMuteMusic")
                        backgroundMusic.run(SKAction.changeVolume(to: Float(0.4), duration: 0))
                    }
                } else {
                    for node in tappedNodes {
                        guard let tapArea = node.parent!.parent as? TapArea else {
                            continue
                        }
                        if !tapArea.isVisible {
                            continue
                        }
                        
                        if tapArea.isTapped {
                            continue
                        }
                        var hideSpeed = 2.5
                        if node.name == "tap" {
                            run(SKAction.playSoundFileNamed("robot-click.aiff", waitForCompletion: false))
                            score += 1
                            hideSpeed = 0.5
                            
                        } else if node.name == "noTap" {
                            // boo! play sound
                            run(SKAction.playSoundFileNamed("wromg.aiff", waitForCompletion: false))
                            
                            score -= 1
                        }
                        tapArea.characterNode.xScale = 0.8
                        tapArea.characterNode.yScale = 0.8
                        tapArea.characterNode.position.y -= 10
                        
                        
                        tapArea.tap(hideSpeed: hideSpeed)
                    }
                }
            }
        }
    }
    
    
    func createTapArea(at position: CGPoint) {
        let tapArea = TapArea()
        tapArea.configure(at: position)
        addChild(tapArea)
        tapAreas.append(tapArea)
    }
    
    func createEnemy() {
        round += 1
        if round >= 107 {
            for tapArea in tapAreas {
                tapArea.hide()
            }
            newGame = true
            let scene = GameScene(fileNamed: "GameOverScene")!
            let transition = SKTransition.crossFade(withDuration: 2)
            self.view?.presentScene(scene, transition: transition)
            return
        }
        popupTime *= 0.99
        tapAreas.shuffle()
        tapAreas[0].show(hideTime: popupTime)
        
        for i in 1...4 {
            if Int.random(in: 0...18) > (i * 4) {
                tapAreas[i].show(hideTime: popupTime)
            }
        }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2.0
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
    
    func restartGame() {
        score = 0
        round = 1
        popupTime = 0.85
        newGame = false
        
        for tapArea in tapAreas {
            tapArea.characterNode.position.y = -120
        }
        
        backgroundMusic.run(SKAction.stop())
        backgroundMusic.run(SKAction.play())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.createEnemy()
        }
    }
    
    
}
