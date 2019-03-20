import UIKit

class CharacterAnimationView: UIView {


  // MARK: - Properties

  let text: String

  private var charLayers = [CAShapeLayer]()

  init(text: String, frame: CGRect) {
    self.text = text
    super.init(frame: frame)
    backgroundColor = UIColor.wwdcBackgroundBlue
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("")
  }

  // MARK: - Public Methods

  func drawText() {
    for layer in self.charLayers {
      layer.removeFromSuperlayer()
    }

    let stringAttributes = [
      NSAttributedString.Key.font: UIFont(name: "Futura-CondensedExtraBold",
                                          size: 64.0) ?? UIFont.systemFont(ofSize: 64),
    ]

    let attributedString = NSMutableAttributedString(string: text,
                                                     attributes: stringAttributes)

    let charPaths = characterPaths(attributedString: attributedString,
                                   position: CGPoint(x: 0,
                                                     y: frame.height)
    )

    self.charLayers = charPaths.map { path in
      let shapeLayer = CAShapeLayer()
      shapeLayer.fillColor = UIColor.clear.cgColor
      shapeLayer.strokeColor = UIColor.white.cgColor
      shapeLayer.lineWidth = 2
      shapeLayer.path = path
      return shapeLayer
    }

    for layer in self.charLayers {
      self.layer.addSublayer(layer)
      self.layer.backgroundColor = UIColor.wwdcBackgroundBlue.cgColor
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.fromValue = 0
      animation.duration = 2.2
      layer.add(animation, forKey: "charAnimation")
    }
  }

  // MARK: - Private Methods

  private func characterPaths(attributedString: NSAttributedString,
                              position: CGPoint) -> [CGPath] {
    let line = CTLineCreateWithAttributedString(attributedString)

    guard let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun] else { return []}

    var characterPaths = [CGPath]()

    for glyphRun in glyphRuns {
      guard let attributes = CTRunGetAttributes(glyphRun) as? [String: AnyObject] else { continue }
      let font = attributes[kCTFontAttributeName as String] as! CTFont

      for index in 0..<CTRunGetGlyphCount(glyphRun) {
        let glyphRange = CFRangeMake(index, 1)

        var glyph = CGGlyph()
        CTRunGetGlyphs(glyphRun, glyphRange, &glyph)

        var characterPosition = CGPoint()
        CTRunGetPositions(glyphRun, glyphRange, &characterPosition)
        characterPosition.x += position.x
        characterPosition.y += position.y

        if let glyphPath = CTFontCreatePathForGlyph(font, glyph, nil) {
          var transform = CGAffineTransform(a: 1,
                                            b: 0,
                                            c: 0,
                                            d: -1,
                                            tx: characterPosition.x,
                                            ty: characterPosition.y
          )
          if let charPath = glyphPath.copy(using: &transform) {
            characterPaths.append(charPath)
          }
        }
      }
    }
    return characterPaths
  }

}

// MARK: WWDC 2019 Background blue

extension UIColor {

  static var wwdcBackgroundBlue: UIColor {
    return UIColor(red: 20 / 255,
                   green: 25 / 255,
                   blue: 45 / 255,
                   alpha: 1)
  }

}
