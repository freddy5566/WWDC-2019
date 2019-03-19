//
//  HttpView.swift
//  WWDC 2019
//
//  Created by jamfly on 15/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//


import UIKit
import SpriteKit
import GameplayKit

public class HttpView: SKView {

  // MARK: - Initialization

  var message = ""

  public init(frame: CGRect, message: EncrytableMessage) {
    let introductionScene = IntroductionScene(size: frame.size, message: message)
    introductionScene.scaleMode = .aspectFill
    super.init(frame: frame)
    self.presentScene(introductionScene)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


}
