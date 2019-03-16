//
//  CharacterState.swift
//  WWDC 2019
//
//  Created by jamfly on 16/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class CharacterState: GKState {

  // MARK: - Properties

  let message: String
  let character: CharacterSprite
  let view: String

  // MARK: - Initialization

  init(message: String, character: CharacterSprite, view: String) {
    self.message = message
    self.character = character
    self.view = view
  }

  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    self.character.text = view
  }


}
