//
//  SceneState.swift
//  WWDC 2019
//
//  Created by jamfly on 16/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import GameplayKit

class SceneState: GKState {

  // MARK: - Properties
  
  let characterA: CharacterSprite
  let characterB: CharacterSprite
  let scene: IntroductionScene

  init(characterA: CharacterSprite,
       characterB: CharacterSprite,
       scene: IntroductionScene) {
    self.characterA = characterA
    self.characterB = characterB
    self.scene = scene
    
    characterA.stateMachine.enter(CharacterSendingState.self)
    characterB.stateMachine.enter(CharacterStartState.self)
  }

}
