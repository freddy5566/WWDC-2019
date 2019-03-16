//
//  CharacterSprite.swift
//  WWDC 2019
//
//  Created by jamfly on 16/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

final class CharacterSprite: SKLabelNode {

  // MARK: - Properties

  let characterName: String
  let waiting: String
  let sending: String
  let recieve: String

  var message: String = "" {
    didSet {
      messageLabel.text = message
    }
  }

  var characterState: [CharacterState] {
    return [
      CharacterStartState(message: message, character: self, view: waiting),
      CharacterSendingState(message: message, character: self, view: sending),
      CharacterRecieveState(message: message, character: self, view: recieve)
    ]
  }

  lazy var stateMachine: GKStateMachine = {
    return GKStateMachine(states: characterState)
  }()

  private lazy var messageLabel: SKLabelNode = {
    let messageLabe = SKLabelNode(fontNamed: "Helvetica")
    messageLabe.text = message
    messageLabe.fontSize = 19
    messageLabe.fontColor = .black
    messageLabe.position = CGPoint(x: 0, y: 75)
    messageLabe.horizontalAlignmentMode = .center
    messageLabe.verticalAlignmentMode = .center
    return messageLabe
  }()

  // MARK: - Initialization

  init(characterName: String, message: String, waiting: String, sending: String, recieve: String) {
    self.characterName = characterName
    self.message = message
    self.waiting = waiting
    self.sending = sending
    self.recieve = recieve
    super.init()
    self.setUp()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("")
  }

  // MARK: - Public Method


  // MARK: - Private Method

  private func messageAboveCharacter() {
    self.addChild(messageLabel)
  }

  private func nameTextAboveName() {
    let nameLabel = SKLabelNode(fontNamed: "Helvetica")
    nameLabel.text = characterName
    nameLabel.fontSize = 19
    nameLabel.fontColor = .black
    nameLabel.position = CGPoint(x: 0, y: 55)
    nameLabel.horizontalAlignmentMode = .center
    nameLabel.verticalAlignmentMode = .center
    self.addChild(nameLabel)
  }

  private func setUpFont() {
    fontSize = 70
    horizontalAlignmentMode = .center
    verticalAlignmentMode = .center
  }

  private func setUp() {
    stateMachine.enter(CharacterStartState.self)
    setUpFont()
    messageAboveCharacter()
    nameTextAboveName()
  }

}
