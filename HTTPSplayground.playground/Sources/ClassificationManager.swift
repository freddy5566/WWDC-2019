//
//  ClassificationManager.swift
//  WWDC 2019
//
//  Created by jamfly on 16/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import CoreML
import NaturalLanguage

public final class ClassificationManager {

  // MARK: - Properties

  public static var shared = ClassificationManager()

  enum Error: Swift.Error {
    case featuresMissing
  }

  private let tagger = NLTagger(tagSchemes: [.nameType])
  private let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
  private let tags: [NLTag] = [.personalName, .placeName, .organizationName]
  private let model = SentimentPolarity()

  public var isBigBrother: Bool = false

  // MARK: - Initialization

  public init() {}

  // MARK: - Public Methods

  public func predictSentiment(from text: String) -> Sentiment {
    do {
      let inputFeatures = features(from: text)
      // Make prediction only with 2 or more words
      guard inputFeatures.count > 1 else {
        throw Error.featuresMissing
      }

      let output = try model.prediction(input: inputFeatures)

      switch output.classLabel {
      case "Pos":
        return .positive
      case "Neg":
        return .negative
      default:
        return .neutral
      }
    } catch {
      return .neutral
    }
  }

  // MARK: - Private Methods

  private func isAboutBigBrother(text: [String]) -> Bool {
    return text.first == "bigbrother" || (text.first == "big" && text[2] == "brother")
  }

  private func features(from text: String) -> [String: Double] {
    var wordCounts = [String: Double]()
    var tokens = [String]()

    tagger.string = text
    let range = text.startIndex..<text.endIndex

    tagger.enumerateTags(in: range, unit: .word, scheme: .nameType) { (tag, tokenRange) -> Bool in
      let token = text[tokenRange].lowercased()
      tokens.append(token)
      guard token.count >= 3 else {
        return true
      }

      if let value = wordCounts[token] {
        wordCounts[token] = value + 1.0
      } else {
        wordCounts[token] = 1.0
      }
      return true
    }

    isBigBrother = isAboutBigBrother(text: tokens)
    return wordCounts
  }
}
