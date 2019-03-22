//
//  Extensions.swift
//  WWDC 2019
//
//  Created by jamfly on 22/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import UIKit
import Vision
import CoreGraphics
import ImageIO

extension UIImage {

  public func resize(to newSize: CGSize) -> UIImage? {
    guard self.size != newSize else { return self }

    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))

    defer { UIGraphicsEndImageContext() }
    return UIGraphicsGetImageFromCurrentImageContext()
  }

  public func pixelBuffer() -> CVPixelBuffer? {
    var pixelBuffer: CVPixelBuffer? = nil

    let width = Int(self.size.width)
    let height = Int(self.size.height)

    CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_OneComponent8, nil, &pixelBuffer)
    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

    let colorspace = CGColorSpaceCreateDeviceGray()
    let bitmapContext = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer!),
                                  width: width,
                                  height: height,
                                  bitsPerComponent: 8,
                                  bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
                                  space: colorspace, bitmapInfo: 0)!

    guard let cg = self.cgImage else {
      return nil
    }

    bitmapContext.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))

    return pixelBuffer
  }

}

extension CGPoint {
  func scaled(to size: CGSize) -> CGPoint {
    return CGPoint(x: self.x * size.width, y: self.y * size.height)
  }
}

extension CGRect {
  func scaled(to size: CGSize) -> CGRect {
    return CGRect(
      x: self.origin.x * size.width,
      y: self.origin.y * size.height,
      width: self.size.width * size.width,
      height: self.size.height * size.height
    )
  }
}

extension CGImagePropertyOrientation {
  init(_ orientation: UIImage.Orientation) {
    switch orientation {
    case .up: self = .up
    case .upMirrored: self = .upMirrored
    case .down: self = .down
    case .downMirrored: self = .downMirrored
    case .left: self = .left
    case .leftMirrored: self = .leftMirrored
    case .right: self = .right
    case .rightMirrored: self = .rightMirrored
    }
  }
}

extension CGMutablePath {
  // Helper function to add lines to a path.
  func addPoints(in landmarkRegion: VNFaceLandmarkRegion2D,
                 applying affineTransform: CGAffineTransform,
                 closingWhenComplete closePath: Bool) {
    let pointCount = landmarkRegion.pointCount

    // Draw line if and only if path contains multiple points.
    guard pointCount > 1 else {
      return
    }
    self.addLines(between: landmarkRegion.normalizedPoints, transform: affineTransform)

    if closePath {
      self.closeSubpath()
    }
  }
}
