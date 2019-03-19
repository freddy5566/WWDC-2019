//
//  HttpsView.swift
//  WWDC 2019
//
//  Created by jamfly on 15/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//


import UIKit
import SpriteKit
import GameplayKit

public class HttpsView: SKView {

  // MARK: - Properties

  var message = ""

  private lazy var textFrame: CGRect = {
    let textFrame = CGRect(x: frame.midX - 150,
                           y: frame.midY - 100,
                           width: 350,
                           height: 100)
    return textFrame
  }()

  // MARK: - Initialization

  public init(frame: CGRect, message: EncrytableMessage) {
    let httpsScene = HttpsScene(size: frame.size,
                                message: message)
    httpsScene.scaleMode = .aspectFill
    super.init(frame: frame)
    self.presentScene(httpsScene)
    setUpNotification()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private methods

  private func setUpNotification() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(textAnimation(notification:)),
                                           name: Notification.Name.FINISH_SCENE,
                                           object: nil)
  }

  @objc private func textAnimation(notification: NSNotification) {
    let backgroundView = UIView(frame: frame)
    backgroundView.backgroundColor = UIColor.wwdcBackgroundBlue
    addSubview(backgroundView)
    
    setUpTextAnimationView()
  }

  private func setUpTextAnimationView() {
    let helloWWDC = CharacterAnimationView(text: "HELLO WWDC",
                                           frame: textFrame)
    helloWWDC.center.x -= 20
    addSubview(helloWWDC)
    helloWWDC.setUp()

    textAnimation(with: helloWWDC)
  }

  private func textAnimation(with helloWWDC: CharacterAnimationView) {
    let jamfly = CharacterAnimationView(text: "It's jamfly",
                                        frame: textFrame)
    jamfly.alpha = 0

    UIView.animate(withDuration: 3, animations: {
      helloWWDC.center.y -= 105
    }) { [weak self] (isCompleted) in
      if !isCompleted { return }
      self?.jamflyAnimation(with: jamfly)
    }
  }

  private func jamflyAnimation(with jamfly: CharacterAnimationView) {
    addSubview(jamfly)
    jamfly.setUp()

    let slogan = CharacterAnimationView(text: "Write code. Blow minds",
                                        frame: textFrame)
    addSubview(slogan)
    slogan.alpha = 0

    UIView.animate(withDuration: 3, animations: {
      jamfly.alpha = 1
    }) { [weak self] (isCompleted) in
      if !isCompleted { return }
      self?.sloganAnimation(with: slogan)
    }
  }

  private func sloganAnimation(with slogan: CharacterAnimationView) {
    slogan.center.y += 105
    slogan.center.x -= 177
    UIView.animate(withDuration: 3) {
      slogan.setUp()
      slogan.alpha = 1
    }
  }

}

extension Notification.Name {
  static let FINISH_SCENE = Notification.Name("FINISH_SCENE")
}
