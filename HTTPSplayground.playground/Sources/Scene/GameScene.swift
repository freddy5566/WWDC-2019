//
//  GameScene.swift
//  WWDC 2019
//
//  Created by jamfly on 15/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {

  // MARK: - Properties

  var message = ""

  lazy var resendButton: SKLabelNode = {
    let resendButton = SKLabelNode(text: "hit me to see\nwhat charile will recieve")
    resendButton.name = "resendButton"
    resendButton.fontColor = UIColor.green
    resendButton.fontName = "Chalkduster"
    resendButton.numberOfLines = 0
    resendButton.fontSize = 18
    return resendButton
  }()

  private var bigBrotherCurrentNode: SKNode?

  private lazy var pigeon: SKSpriteNode = {
    let pigeon = SKSpriteNode(imageNamed: "pigeon_right")
    pigeon.scale(to: CGSize(width: 50, height: 50))
    pigeon.name = "pigeon"
    pigeon.physicsBody = SKPhysicsBody(rectangleOf: pigeon.size)
    pigeon.physicsBody?.categoryBitMask = PhysicsCategory.pigeon
    pigeon.physicsBody?.contactTestBitMask = PhysicsCategory.bigBrother
    pigeon.physicsBody?.collisionBitMask = 0
    pigeon.physicsBody?.isDynamic = true
    return pigeon
  }()

  private lazy var jamfly: CharacterSprite = {
    let jamfly = CharacterSprite(characterName: "jamfly",
                                 message: message,
                                 waiting: "🙋‍♂️",
                                 sending: "🙎‍♂️",
                                 recieve: "🙆‍♂️")
    jamfly.name = "jamfly"
    return jamfly
  }()

  private lazy var charile: CharacterSprite = {
    let charile = CharacterSprite(characterName: "charile",
                                  message: "",
                                  waiting: "🙋‍♀️",
                                  sending: "🙍‍♀️",
                                  recieve: "🙆‍♀️")
    charile.name = "charile"
    charile.physicsBody = SKPhysicsBody(rectangleOf: charile.frame.size)
    charile.physicsBody?.categoryBitMask = PhysicsCategory.charile
    charile.physicsBody?.contactTestBitMask = PhysicsCategory.pigeon
    charile.physicsBody?.collisionBitMask = 0
    charile.physicsBody?.isDynamic = true
    return charile
  }()

  private let bigBrother: SKLabelNode = {
    let bigBrother = SKLabelNode(text: "🎩")
    bigBrother.name = "big brother"
    bigBrother.physicsBody = SKPhysicsBody(rectangleOf: bigBrother.frame.size)
    bigBrother.physicsBody?.categoryBitMask = PhysicsCategory.bigBrother
    bigBrother.physicsBody?.contactTestBitMask = PhysicsCategory.pigeon
    bigBrother.physicsBody?.collisionBitMask = 0
    bigBrother.physicsBody?.isDynamic = true
    return bigBrother
  }()

  private lazy var sceneStates: [SceneState] = {
    let states: [SceneState] = [
      SceneStartState(characterA: jamfly, characterB: charile, scene: self),
      SceneFoundState(characterA: jamfly, characterB: charile, scene: self),
      SceneResendingState(characterA: jamfly, characterB: charile, scene: self),
      SceneRecieveState(characterA: jamfly, characterB: charile, scene: self)
    ]
    return states
  }()

  private lazy var sceneStateMachine: GKStateMachine = {
    return GKStateMachine(states: sceneStates)
  }()

  // MARK: - Initialization

  init(size: CGSize, message: String) {
    self.message = message
    super.init(size: size)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("")
  }

  override func sceneDidLoad() {
    super.sceneDidLoad()
    backgroundColor = SKColor.white
    setupWorldPhysics()
    sceneStateMachine.enter(SceneStartState.self)
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)
    jamfly.position = CGPoint(x: size.width * 0.2,
                              y: 50)
    charile.position = CGPoint(x: size.width * 0.8,
                               y: jamfly.position.y)
    pigeon.position = CGPoint(x: jamfly.position.x,
                              y: jamfly.position.y + 50)
    bigBrother.position = CGPoint(x: size.width / 2, y: 100)
    resendButton.position = CGPoint(x: size.width * 0.75, y: 550.0)

    addChild(pigeon)
    addChild(jamfly)
    addChild(charile)
    addChild(bigBrother)
    addChild(resendButton)
    resendButton.isHidden = true
    moveRight()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    if let touch = touches.first {
      let location = touch.location(in: self)

      let touchedNodes = self.nodes(at: location)
      for node in touchedNodes.reversed() {
        if node.name == "big brother" {
          self.bigBrotherCurrentNode = node
        }

        if node.name == "resendButton" {
          print("button pressed")
          bigBrotherFly()
        }

      }

    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first, let node = bigBrotherCurrentNode {
      let touchLocation = touch.location(in: self)

      node.position = touchLocation
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.bigBrotherCurrentNode = nil
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.bigBrotherCurrentNode = nil
  }

  // MARK: - Public Methods

  // MARK: - Private Methods

  private func bigBrotherFly() {
    sceneStateMachine.enter(SceneResendingState.self)
    pigeon.isPaused = false
    resend()
  }

  private func moveRight() {
    let path = UIBezierPath()
    path.move(to: CGPoint.zero)
    let mid = (charile.position.x - jamfly.position.x) / 2
    path.addQuadCurve(to: CGPoint(x: charile.position.x,
                                  y: charile.position.y),
                      controlPoint:  CGPoint(x: mid,
                                             y: charile.position.y + 20))
    let quadCurve = SKAction.follow(path.cgPath, speed: 100)
    pigeon.run(quadCurve)
  }

  private func resend() {
    let action = SKAction.move(to: CGPoint(x: charile.position.x,
                                           y: charile.position.y),
                               duration: 3)
    pigeon.run(action)
  }

}

// MARK: - SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
  
  private func worldPhysicsBody(frame:CGRect) -> SKPhysicsBody {
    let body = SKPhysicsBody(edgeLoopFrom: frame)
    body.affectedByGravity = false
    return body
  }

  private func setupWorldPhysics() {
    self.physicsWorld.contactDelegate = self
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    self.physicsBody = worldPhysicsBody(frame: self.frame)
  }

  func didBegin(_ contact: SKPhysicsContact) {
    let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

    if collision == PhysicsCategory.pigeon | PhysicsCategory.bigBrother {
      print("big brother found it")
      pigeon.removeAllActions()
      pigeon.isPaused = true
      pigeon.physicsBody?.contactTestBitMask = PhysicsCategory.charile
      sceneStateMachine.enter(SceneFoundState.self)
    } else if collision == PhysicsCategory.pigeon | PhysicsCategory.charile {
      pigeon.isPaused = true
      pigeon.removeAllActions()
      print("charile hit")
      print(sceneStateMachine.enter(SceneRecieveState.self))
    }
  }

}
