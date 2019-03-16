//
//  PhysicsCategory.swift
//  WWDC 2019
//
//  Created by jamfly on 15/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation

public struct PhysicsCategory {

  static let none: UInt32         = 0
  static let all: UInt32          = UInt32.max

  static let pigeon: UInt32       = 1 << 0
  static let jamfly: UInt32       = 1 << 1
  static let charile: UInt32      = 1 << 2
  static let bigBrother: UInt32   = 1 << 3
  
}
