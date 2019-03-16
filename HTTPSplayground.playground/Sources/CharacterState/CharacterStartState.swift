//
//  CharacterStartState.swift
//  WWDC 2019
//
//  Created by jamfly on 16/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import GameplayKit

final class CharacterStartState: CharacterState {

  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
  }

  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
  }

  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is CharacterSendingState.Type
  }

}
