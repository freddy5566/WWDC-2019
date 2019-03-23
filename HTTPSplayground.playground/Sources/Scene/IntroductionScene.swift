//
//  IntroductionScene.swift
//  WWDC 2019
//
//  Created by jamfly on 15/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit
import PlaygroundSupport

class IntroductionScene: SKScene {

  // MARK: - Properties

  var message = EncrytableMessage(message: "")

  lazy var resendButton: SKLabelNode = {
    let resendButton = SKLabelNode(text: "Hit me to see\nwhat charlie will recieve")
    resendButton.name = "resendButton"
    resendButton.fontColor = UIColor.green
    resendButton.fontName = "Chalkduster"
    resendButton.numberOfLines = 0
    resendButton.fontSize = 18
    resendButton.isHidden = true
    return resendButton
  }()

  private var pigeonCurrentNode: SKNode?

  private lazy var nextSceneButton: SKLabelNode = {
    let nextSceneButton = SKLabelNode(text: "Hit me to see next")
    nextSceneButton.name = "nextSceneButton"
    nextSceneButton.fontColor = UIColor.green
    nextSceneButton.fontName = "Chalkduster"
    nextSceneButton.numberOfLines = 0
    nextSceneButton.fontSize = 36
    nextSceneButton.alpha = 0
    return nextSceneButton
  }()

  private lazy var pigeon: SKSpriteNode = {
    let pigeon = SKSpriteNode(imageNamed: "pigeon_right")

    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
    let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
    if let dirPath          = paths.first
    {
      let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("drawing_pigeion.jpg")
      if let image    = UIImage(contentsOfFile: imageURL.path) {
        pigeon.texture = SKTexture(image: image)
      } else {
        print("cannot get image from url")
      }
    } else {
      print("cannot get dirPath")
    }

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
                                 message: message.messageString,
                                 waiting: "🙋‍♂️",
                                 sending: "🙎‍♂️",
                                 recieve: "🙆‍♂️")
    jamfly.name = "jamfly"
    return jamfly
  }()

  private lazy var charlie: CharacterSprite = {
    let charlie = CharacterSprite(characterName: "charlie",
                                  message: "",
                                  waiting: "🙋‍♀️",
                                  sending: "🙍‍♀️",
                                  recieve: "🙆‍♀️")
    charlie.name = "charlie"
    charlie.physicsBody = SKPhysicsBody(rectangleOf: charlie.frame.size)
    charlie.physicsBody?.categoryBitMask = PhysicsCategory.charlie
    charlie.physicsBody?.contactTestBitMask = PhysicsCategory.pigeon
    charlie.physicsBody?.collisionBitMask = 0
    charlie.physicsBody?.isDynamic = true
    return charlie
  }()

  private let bigBrother: SKLabelNode = {
    let bigBrother = SKLabelNode(text: "🖥")
    bigBrother.name = "big brother's TV"
    bigBrother.physicsBody = SKPhysicsBody(rectangleOf: bigBrother.frame.size)
    bigBrother.physicsBody?.categoryBitMask = PhysicsCategory.bigBrother
    bigBrother.physicsBody?.contactTestBitMask = PhysicsCategory.pigeon
    bigBrother.physicsBody?.collisionBitMask = 0
    bigBrother.physicsBody?.isDynamic = true
    return bigBrother
  }()

  private lazy var sceneStates: [SceneState] = {
    let states: [SceneState] = [
      SceneStartState(characterA: jamfly, characterB: charlie, scene: self),
      SceneFoundState(characterA: jamfly, characterB: charlie, scene: self),
      SceneResendingState(characterA: jamfly, characterB: charlie, scene: self),
      SceneRecieveState(characterA: jamfly, characterB: charlie, scene: self)
    ]
    return states
  }()

  private lazy var sceneStateMachine: GKStateMachine = {
    return GKStateMachine(states: sceneStates)
  }()

  private var isFound = false

  // MARK: - Initialization

  init(size: CGSize, message: EncrytableMessage) {
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
    SpeakManager.shared.dragThePigeion()
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)
    jamfly.position = CGPoint(x: size.width * 0.2,
                              y: 50)
    charlie.position = CGPoint(x: size.width * 0.8,
                               y: jamfly.position.y)
    pigeon.position = CGPoint(x: jamfly.position.x,
                              y: jamfly.position.y + 100)
    bigBrother.position = CGPoint(x: frame.midX,
                                  y: frame.height - 50)
    resendButton.position = CGPoint(x: size.width * 0.75,
                                    y: 550.0)
    nextSceneButton.position = CGPoint(x: frame.midX, y: frame.midY)

    addChild(pigeon)
    addChild(jamfly)
    addChild(charlie)
    addChild(bigBrother)
    addChild(resendButton)
    addChild(nextSceneButton)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    if let touch = touches.first {
      let location = touch.location(in: self)

      let touchedNodes = self.nodes(at: location)
      for node in touchedNodes.reversed() {
        if node.name == "pigeon" {
          pigeonCurrentNode = node
        } else if node.name == "resendButton" {
          sceneStateMachine.enter(SceneResendingState.self)
          pigeon.isHidden = false
        } else if node.name == "nextSceneButton" {
          let frame = CGRect(x: 0, y: 0, width: 750, height: 650)
          let message = EncrytableMessage(message: "HELLO WWDC", encrytableProtocol: .caesar(key: 8))
          PlaygroundPage.current.liveView = HttpsView(frame: frame, message: message)
        }
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first, let node = pigeonCurrentNode {
      let touchLocation = touch.location(in: self)
      node.position = touchLocation
      if !isFound && node.position.x >= bigBrother.position.x {
        bigBrotherFound()
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    pigeonCurrentNode = nil
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    pigeonCurrentNode = nil
  }

  // MARK: - Private Methods

  private func bigBrotherFound() {
    isFound = true
    pigeon.isHidden = true
    pigeon.physicsBody?.contactTestBitMask = PhysicsCategory.charlie
    sceneStateMachine.enter(SceneFoundState.self)
  }

}

// MARK: - SKPhysicsContactDelegate

extension IntroductionScene: SKPhysicsContactDelegate {
  
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

  private func pigeonFlyAway() {
    pigeon.run(SKAction.move(to: CGPoint(x: frame.midX,
                                         y: frame.midY),
                             duration: 3)) { [weak self] in
                              self?.pigeonDisiss()
    }
  }

  private func pigeonDisiss() {
    pigeon.run(SKAction.fadeOut(withDuration: 2)) { [weak self] in
      self?.nextSceneButton.run(SKAction.fadeIn(withDuration: 2))
    }
  }

  private func enterFinalSceneAnimation() {
    charlie.run(SKAction.fadeOut(withDuration: 3))
    jamfly.run(SKAction.fadeOut(withDuration: 3))
    bigBrother.run(SKAction.fadeOut(withDuration: 3))
    pigeonFlyAway()
  }

  func didBegin(_ contact: SKPhysicsContact) {
    let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

    if collision == PhysicsCategory.pigeon | PhysicsCategory.bigBrother {
      bigBrotherFound()
    } else if collision == PhysicsCategory.pigeon | PhysicsCategory.charlie {
      sceneStateMachine.enter(SceneRecieveState.self)
      charlie.stateMachine.enter(CharacterRecieveState.self)
      enterFinalSceneAnimation()
    }
  }

}
