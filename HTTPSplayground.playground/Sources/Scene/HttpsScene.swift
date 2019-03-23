//
//  HttpsScene.swift
//  WWDC 2019
//
//  Created by jamfly on 18/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit

class HttpsScene: SKScene {

  // MARK: - Properties

  var message = EncrytableMessage(message: "")
  var whoSignIt = ""

  private var pigeonNode: SKNode?

  private lazy var pigeon: PigeonSprite = {
    let pigeon = PigeonSprite(texture: nil,
                              color: UIColor.white,
                              size: CGSize(width: 50,
                                           height: 100)
    )
    pigeon.physicsBody = SKPhysicsBody(rectangleOf: pigeon.frame.size)
    pigeon.physicsBody?.categoryBitMask = PhysicsCategory.pigeon
    pigeon.physicsBody?.contactTestBitMask = PhysicsCategory.all
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
    jamfly.physicsBody = SKPhysicsBody(rectangleOf: jamfly.frame.size)
    jamfly.physicsBody?.categoryBitMask = PhysicsCategory.jamfly
    jamfly.physicsBody?.contactTestBitMask = PhysicsCategory.pigeon
    jamfly.physicsBody?.collisionBitMask = 0
    jamfly.physicsBody?.isDynamic = true
    return jamfly
  }()

  private lazy var charlie: CharacterSprite = {
    let charlie = CharacterSprite(characterName: "charlie",
                                  message: "please sign the box and send the message to me",
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

  private lazy var tim: CharacterSprite = {
    let tim = CharacterSprite(characterName: "tim",
                                  message: "come here to get signature",
                                  waiting: "🎅",
                                  sending: "🎅",
                                  recieve: "🎅")
    tim.name = "tim"
    tim.physicsBody = SKPhysicsBody(rectangleOf: charlie.frame.size)
    tim.physicsBody?.categoryBitMask = PhysicsCategory.tim
    tim.physicsBody?.contactTestBitMask = PhysicsCategory.pigeon
    tim.physicsBody?.collisionBitMask = 0
    tim.physicsBody?.isDynamic = true
    return tim
  }()

  private lazy var pigeonStates: [PigeonState] = {
    let pigeonStates = [
      PigeonNoSignState(pigeon: pigeon),
      PigeonSignedState(pigeon: pigeon)
    ]
    return pigeonStates
  }()

  private lazy var pigeonStateMachine: GKStateMachine = {
    return GKStateMachine(states: pigeonStates)
  }()

  // MARK: - Initialization

  init(size: CGSize, message: EncrytableMessage) {
    self.message = message
    super.init(size: size)
    pigeonStateMachine.enter(PigeonNoSignState.self)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("")
  }

  override func sceneDidLoad() {
    super.sceneDidLoad()
    backgroundColor = SKColor.white
    setupWorldPhysics()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(removeSelf),
                                           name: Notification.Name.FINISH_SCENE,
                                           object: nil)
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)
    view.backgroundColor = UIColor.wwdcBackgroundBlue
    
    jamfly.position = CGPoint(x: size.width * 0.2,
                              y: 50)
    charlie.position = CGPoint(x: size.width * 0.8,
                               y: jamfly.position.y)
    pigeon.position = CGPoint(x: jamfly.position.x,
                              y: jamfly.position.y + 100)
    tim.position = CGPoint(x: size.width / 2,
                           y: size.height / 2)

    addChild(pigeon)
    addChild(jamfly)
    addChild(charlie)
    addChild(tim)

    pigeon.run(SKAction.fadeIn(withDuration: 3))
    jamfly.run(SKAction.fadeIn(withDuration: 3))
    charlie.run(SKAction.fadeIn(withDuration: 3))
    tim.run(SKAction.fadeIn(withDuration: 3))
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    if let touch = touches.first {
      let location = touch.location(in: self)
      let touchedNodes = self.nodes(at: location)
      
      for node in touchedNodes.reversed() {
        if node.name == "pigeon" {
          pigeonNode = node
        }
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first, let node = pigeonNode {
      let touchLocation = touch.location(in: self)

      node.position = touchLocation
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    pigeonNode = nil
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    pigeonNode = nil
  }

  // MARK: - Private Methods

  @objc
  private func removeSelf(notification: NSNotification) {
    removeFromParent()
    view?.presentScene(nil)
  }

  private func endingAnimation() {
    tim.run(SKAction.fadeOut(withDuration: 3))
    jamfly.run(SKAction.fadeOut(withDuration: 3))
    charlie.run(SKAction.fadeOut(withDuration: 3))
    pigeonFlyAway()
  }

  private func pigeonFlyAway() {
    pigeon.run(SKAction.move(to: CGPoint(x: frame.midX,
                                         y: frame.midY),
                             duration: 3)) { [weak self] in
                              let sequence = SKAction.sequence([SKAction.fadeOut(withDuration: 3),
                                                                SKAction.removeFromParent()])
                              self?.pigeon.pigeon.run(sequence)
                              self?.wwdcFinalAnimation()
    }
  }

  private func wwdcFinalAnimation() {
    pigeon.size = CGSize(width: frame.width,
                         height: frame.height)
    pigeon.wwdcRotation()
    pigeon.wwdcResize()
  }
  
}

// MARK: - SKPhysicsContactDelegate

extension HttpsScene: SKPhysicsContactDelegate {

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

    if collision == PhysicsCategory.pigeon | PhysicsCategory.tim {
      if pigeonStateMachine.currentState is PigeonNoSignState {
        pigeonStateMachine.enter(PigeonSignedState.self)
        tim.message = "I've signed the box, now pigeon can deliver message safely"
        SpeakManager.shared.getSign()
      }
    } else if collision == PhysicsCategory.pigeon | PhysicsCategory.jamfly {
      if pigeonStateMachine.currentState is PigeonSignedState {
        charlie.message = "I cannot wait to see message."
        jamfly.stateMachine.enter(CharacterSendingState.self)
        SpeakManager.shared.getMessage()
      } 
    } else if collision == PhysicsCategory.pigeon | PhysicsCategory.charlie {
      if pigeonStateMachine.currentState is PigeonSignedState &&
        jamfly.stateMachine.currentState is CharacterSendingState {
        SpeakManager.shared.recieveMessage()
        charlie.message = message.messageString
        charlie.stateMachine.enter(CharacterRecieveState.self)
        endingAnimation()
      }
    }
  }

}
