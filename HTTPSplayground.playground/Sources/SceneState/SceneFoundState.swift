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
    adjustLabelFontSizeToFitRect(labelNode: bigBrotherDialog,
                                 rect: CGRect(x: 50,
                                              y: 50,
                                              width: scene.frame.width * 0.8,
                                              height: scene.frame.height * 0.8))
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

  private func bigBrotherDecodeMessage() -> String {
    let encodedString = scene.message.caesarEncode()
    let decodedString = scene.message.messageString

    bigBrotherChangeMessage(scene.message.messageString)

    return BigBrotherMessags.bigbrotherFoundCaesar.rawValue +
      encodedString +
      BigBrotherMessags.bigBrotherCanDecode.rawValue +
      BigBrotherMessags.bigBrotherSaidOriginalMessage.rawValue +
    decodedString
  }

  private func bigBrotherTalk() -> String {
    switch scene.message.encrytableProtocol {
    case .caesar(key: _):
      return bigBrotherDecodeMessage()
    default:
       return bigBrotherPredict(scene.message.messageString)
    }
  }

  private func bigBrotherPredict(_ input: String) -> String {
    let predict = ClassificationManager.shared.predictSentiment(from: input)
    var bigBrotherSaid = ""
    if predict == .negative && ClassificationManager.shared.isBigBrother {
      bigBrotherSaid = BigBrotherMessags.bigBrotherFoundYouSaidSomethingBad.rawValue
      scene.message.messageString = BigBrotherMessags.bigBrotherIsGreat.rawValue
    } else {
      bigBrotherSaid = BigBrotherMessags.bigBrotherDontCare.rawValue
    }
    return bigBrotherSaid
  }

  private func bigBrotherChangeMessage(_ input: String) {
    let predict = ClassificationManager.shared.predictSentiment(from: input)
    if predict == .negative && ClassificationManager.shared.isBigBrother {
      scene.message.messageString = BigBrotherMessags.bigBrotherIsGreat.rawValue
    }
  }

  private func adjustLabelFontSizeToFitRect(labelNode: SKLabelNode, rect: CGRect) {
    let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)

    labelNode.fontSize *= scalingFactor
    labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
  }
}

