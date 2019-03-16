//
//  SceneFoundState.swift
//  WWDC 2019
//
//  Created by jamfly on 16/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import GameplayKit

class SceneFoundState: SceneState {

  // MARK: - Properties

  private lazy var bigBrotherDialog: SKLabelNode = {
    let message = bigBrotherTalk()
    let bigBrotherDialog = BigBrotherFoundView(message: message)
    bigBrotherDialog.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
    return bigBrotherDialog
  }()

  // MARK: - Override Methods

  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    scene.backgroundColor = UIColor.gray
    characterA.stateMachine.enter(CharacterSendingState.self)
    characterB.stateMachine.enter(CharacterStartState.self)
    scene.addChild(bigBrotherDialog)
    scene.resendButton.isHidden = false
  }

  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    scene.backgroundColor = UIColor.white
    bigBrotherDialog.removeFromParent()
    scene.resendButton.isHidden = true
  }

  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is SceneResendingState.Type
  }

  // MARK: - Private Methods

  private func bigBrotherTalk() -> String {
    let predict = ClassificationManager.shared.predictSentiment(from: scene.message)
    var bigBrotherSaid = ""
    if predict == .negative && ClassificationManager.shared.isBigBrother {
      bigBrotherSaid = BigBrotherMessags.bigBrotherFoundYouSaidSomethingBad.rawValue
      scene.message = BigBrotherMessags.bigBrotherIsGreat.rawValue
    } else {
      bigBrotherSaid = BigBrotherMessags.bigBrotherDontCare.rawValue
    }
    return bigBrotherSaid
  }
  
}
