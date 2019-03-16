//
//  SceneResendingState.swift
//  WWDC 2019
//
//  Created by jamfly on 16/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import GameplayKit

class SceneResendingState: SceneState {

  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    characterB.stateMachine.enter(CharacterSendingState.self)
  }

  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is SceneRecieveState.Type
  }


}
