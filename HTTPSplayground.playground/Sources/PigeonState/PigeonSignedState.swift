//
//  PigeonSignedState.swift
//  WWDC 2019
//
//  Created by jamfly on 18/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class PigeonSignedState: PigeonState  {

  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    pigeon.signed()
  }

}
