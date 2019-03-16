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

  // MARK: - Initialization

  var message = ""

  public init(frame: CGRect, message: String) {
    let gameScene = GameScene(size: frame.size, message: message)
    gameScene.scaleMode = .aspectFill
    super.init(frame: frame)
    self.presentScene(gameScene)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


}
