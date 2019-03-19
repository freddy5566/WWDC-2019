//
//  PigeonState.swift
//  WWDC 2019
//
//  Created by jamfly on 18/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class PigeonState: GKState {

  // MARK: - Properties

  let pigeon: PigeonSprite

  // MARK: - Initialization

  init(pigeon: PigeonSprite) {
    self.pigeon = pigeon
  }

  // MARK: - Initialization

  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
  }

}
