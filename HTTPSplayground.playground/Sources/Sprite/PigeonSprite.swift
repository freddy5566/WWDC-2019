//
//  PigeonSprite.swift
//  WWDC 2019
//
//  Created by jamfly on 18/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

final class PigeonSprite: SKSpriteNode {

  // MARK: - Properties

  lazy var pigeon: SKSpriteNode = {
    let pigeon = SKSpriteNode(imageNamed: "pigeon_right")

    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
    let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
    if let dirPath          = paths.first
    {
      let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("drawing_pigeion.jpg")
      if let image    = UIImage(contentsOfFile: imageURL.path) {
        pigeon.texture = SKTexture(image: image)
      } else {
        print("cannot get image from url")
      }
    } else {
      print("cannot get dirPath")
    }
    
    pigeon.scale(to: CGSize(width: 50, height: 50))
    pigeon.physicsBody = SKPhysicsBody(rectangleOf: pigeon.size)
    pigeon.physicsBody?.categoryBitMask = PhysicsCategory.pigeon
    pigeon.physicsBody?.collisionBitMask = 0
    pigeon.physicsBody?.isDynamic = true
    return pigeon
  }()

  private lazy var cage: SKSpriteNode = {
    let cage = SKSpriteNode(imageNamed: "cage")
    //cage.scale(to: CGSize(width: 50, height: 50))
    cage.size = CGSize(width: 50, height: 50)
    cage.name = "cage"
    cage.physicsBody = SKPhysicsBody(rectangleOf: pigeon.size)
    cage.physicsBody?.collisionBitMask = 0
    cage.physicsBody?.isDynamic = true
    return cage
  }()

  // MARK: - Initialization

  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
    setUp()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("")
  }

  // MARK: - Public Methods

  func signed() {
    cage.texture = SKTexture(imageNamed: "wwdc-2019.jpg")
  }

  func wwdcRotation() {
    cage.position = CGPoint(x: frame.minX,
                            y: frame.minY)
    let fadeOut = SKAction.fadeOut(withDuration: 3)
    let rotation = SKAction.rotate(byAngle: 2 * CGFloat.pi,
                                   duration: 3)
    cage.run(fadeOut)
    cage.run(rotation)
  }

  func wwdcResize() {
    cage.run(SKAction.resize(byWidth: frame.width,
                             height: frame.height,
                             duration: 3),
             completion: {
              NotificationCenter.default.post(name: Notification.Name.FINISH_SCENE,
                                              object: nil)
    })
  }

  // MARK: - Private Methods

  private func setUp() {
    pigeon.position = CGPoint(x: 0, y: 50)
    cage.position = CGPoint(x: 0, y: 0)
    addChild(pigeon)
    addChild(cage)
    name = "pigeon"
  }

}
