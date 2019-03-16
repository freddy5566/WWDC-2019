//
//  BigBrotherFoundView.swift
//  WWDC 2019
//
//  Created by jamfly on 15/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//


import SpriteKit

final class BigBrotherFoundView: SKLabelNode {

  // MARK: - Properties

  private let message: String


  // MARK: - Initialization

  public init(message: String) {
    self.message = message
    super.init()
    self.setUp()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("")
  }

  // MARK: - Provate Methods

  private func setUp() {
    text = message
    fontName = "Chalkduster"
    fontColor = SKColor.green
    position = CGPoint(x: frame.midX, y: frame.midY)
    numberOfLines = 0
  }

}
