//
//  EccrytableMessage.swift
//  WWDC 2019
//
//  Created by jamfly on 17/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation

public enum EncrytableProtocol {
  case none
  case caesar(key: Int)
}

public struct EncrytableMessage {

  // MARK: - Properts

  var messageString: String = ""

  let encrytableProtocol: EncrytableProtocol
  private let key: Int

  // MARK: - Initialization

  public init(message: String, encrytableProtocol: EncrytableProtocol = .none) {
    self.messageString = message
    self.encrytableProtocol = encrytableProtocol
    switch encrytableProtocol {
    case .caesar(let key):
      self.key = key
    default:
      self.key = 0
    }
  }

  // MARK: - Public Methods

  public func caesarEncode() -> String {
    return caesarCipher(messageString, shiftBy: key)
  }

  public func caesarDecode() -> String {
    return caesarCipher(messageString, shiftBy: -key)
  }

  // MARK: - Private Methods

  private func caesarCipher(_ input: String, shiftBy: Int) -> String {
    let letterA = Int("a".utf16.first!)
    let letterZ = Int("z".utf16.first!)
    let letterCount = letterZ - letterA + 1

    var result = [UInt16]()
    result.reserveCapacity(input.utf16.count)

    for char in input.utf16 {
      let value = Int(char)
      switch value {
      case letterA...letterZ:
        let offset = value - letterA
        var newOffset = (offset + shiftBy) % letterCount
        if newOffset < 0 { newOffset += letterCount }
        result.append(UInt16(letterA + newOffset))
      default:
        result.append(char)
      }
    }

    return String(utf16CodeUnits: &result, count: result.count)
  }

}

extension String {
  var asciiArray: [UInt32] {
    return unicodeScalars.filter{$0.isASCII}.map{$0.value}
  }
}

extension Character {
  var asciiValue: UInt32? {
    return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
  }
}
