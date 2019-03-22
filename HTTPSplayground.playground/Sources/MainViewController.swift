//
//  MainViewController.swift
//  WWDC 2019
//
//  Created by jamfly on 22/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import UIKit
import Vision
import CoreImage
import ImageIO

final public class MainViewController: DrawableViewController {

  // MARK: - Properties

  var message = EncrytableMessage(message: "")

  private lazy var titleLabel: UILabel = {
    let frame = CGRect(x: 60,
                       y: 45,
                       width: view.frame.width,
                       height: 50)
    let titleLabel = UILabel(frame: frame)
    titleLabel.text = "What's the year of the WWDC"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
    titleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 10)
    return titleLabel
  }()

  private lazy var clearButton: UIButton = {
    let frame = CGRect(x: view.frame.maxX - 300,
                       y: 50,
                       width: 100,
                       height: 50)
    let clearButton = UIButton(frame: frame)
    clearButton.backgroundColor = UIColor.wwdcBackgroundBlue
    clearButton.setTitle("Clear", for: .normal)
    clearButton.addTarget(self,
                          action: #selector(clear),
                          for: .touchUpInside)
    return clearButton
  }()

  private lazy var finishedButton: UIButton = {
    let frame = CGRect(x: view.frame.maxX - 150,
                       y: 50,
                       width: 100,
                       height: 50)
    let finishedButton = UIButton(frame: frame)
    finishedButton.backgroundColor = UIColor.wwdcBackgroundBlue
    finishedButton.setTitle("Done", for: .normal)
    finishedButton.addTarget(self,
                             action: #selector(finishedPressed),
                             for: .touchUpInside)
    return finishedButton
  }()

  private lazy var textDetectionRequest: VNDetectTextRectanglesRequest = {
    let textDetectRequest = VNDetectTextRectanglesRequest(completionHandler:  handleDetectedText)
    textDetectRequest.reportCharacterBoxes = true
    return textDetectRequest
  }()

  private var pathLayer: CALayer?
  private var predictImage: UIImage?

  // MARK: - Initialization

  public init(message: EncrytableMessage) {
    self.message = message
    super.init(nibName: nil, bundle: nil)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("")
  }

  // MARK: - Life Cycle

  public override func viewDidLoad() {
    super.viewDidLoad()

    let backgroundImage = UIImage(named: "tim_apple_ipad_0")
    backgroundImageView.image = backgroundImage

    view.addSubview(titleLabel)
    view.addSubview(clearButton)
    view.addSubview(finishedButton)

    setUpPathLayer()
  }

  // MARK: - Button Actions

  @objc
  private func clear() {
    print("clear pressed")
    pathLayer?.removeFromSuperlayer()
    pathLayer = nil
    setUpPathLayer()

    DispatchQueue.main.async { [weak self] in
      self?.mainImageView.image = nil
      print("self?.mainImageView.image = nil")
    }
  }

  @objc
  private func finishedPressed() {
    storeImage()
    presentDraw()
  }

  // MARK: - Private Methods

  private func storeImage() {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileName = "drawing.jpg"
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    if let data = mainImageView.image!.jpegData(compressionQuality:  1.0) {
      do {
        try data.write(to: fileURL)
        print("file saved")

        guard let image = UIImage(data: data) else {
          print("failed to get predictImage")
          return
        }
        predictImage = image
        predict()
      } catch {
        print("error saving file:", error)
        }
    }
  }

  private func presentDraw() {
    let drawingVC = DrawingViewController()
    present(drawingVC, animated: true, completion: nil)
  }

  private func setUpPathLayer() {
    // Prepare pathLayer to hold Vision results.
    let drawingLayer = CALayer()
    drawingLayer.bounds = mainImageView.bounds
    drawingLayer.anchorPoint = CGPoint.zero
    drawingLayer.position = CGPoint(x: 0, y: 0)
    drawingLayer.opacity = 0.5
    pathLayer = drawingLayer
    DispatchQueue.main.async { [weak self] in
      guard let pathLayer = self?.pathLayer else { return }
      self?.view.layer.addSublayer(pathLayer)
    }
  }

  private func predict() {
    guard let cgImage = predictImage?.cgImage else { return }
    let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage,
                                                    options: [:])
    let request: [VNRequest] = [textDetectionRequest]
    // Send the requests to the request handler.

    DispatchQueue.global(qos: .userInitiated).async {
      do {
        try imageRequestHandler.perform(request)
      } catch let error as NSError {
        print("Failed to perform image request: \(error)")
        return
      }
    }
  }

  private func handleDetectedText(request: VNRequest?, error: Error?) {
    // Perform drawing on the main thread.
    DispatchQueue.main.async { [weak self] in
      guard let drawLayer = self?.pathLayer,
        let results = request?.results as? [VNTextObservation] else {
          return
      }
      if results.isEmpty {
        self?.presentAlert()
        return
      }
      self?.draw(text: results, onImageWithBounds: drawLayer.bounds)
      drawLayer.setNeedsDisplay()
    }
  }

  private func presentAlert() {
    // Always present alert on main thread.
    DispatchQueue.main.async { [weak self] in
      let alertController = UIAlertController(title: "Failed",
                                              message: "Sorry cannot detect digit, try it again.",
                                              preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Try again",
                                   style: .default) { [weak self] _ in
                                    self?.clear()
      }
      alertController.addAction(okAction)
      self?.present(alertController, animated: true, completion: nil)
    }
  }

  private func draw(text: [VNTextObservation], onImageWithBounds bounds: CGRect) {
    CATransaction.begin()
    for wordObservation in text {
      let wordBox = boundingBox(forRegionOfInterest: wordObservation.boundingBox, withinImageBounds: bounds)
      let wordLayer = shapeLayer(color: .red, frame: wordBox)

      // Add to pathLayer on top of image.
      pathLayer?.addSublayer(wordLayer)

      // Iterate through each character within the word and draw its box.
      guard let charBoxes = wordObservation.characterBoxes else {
        continue
      }
      for charObservation in charBoxes {
        let charBox = boundingBox(forRegionOfInterest: charObservation.boundingBox, withinImageBounds: bounds)
        let charLayer = shapeLayer(color: .purple, frame: charBox)

        charLayer.borderWidth = 1

        // Add to pathLayer on top of image.
        pathLayer?.addSublayer(charLayer)

        predictDigit(at: charLayer.frame)
      }
      CATransaction.commit()
    }
  }

  private func predictDigit(at charBox: CGRect) {
    guard let cgimage = predictImage?.cgImage?.cropping(to: charBox) else {
      print("there's no cgimage")
      return
    }

    let ciimage = CIImage(cgImage: cgimage)

    let image = UIImage(ciImage: ciimage.applyingFilter("CIColorInvert"))

    guard let realImage = image.resize(to: CGSize(width: 28, height: 28)) else {
      print("there's no realimage")
      return
    }

    guard let pixelBuffer = realImage.pixelBuffer() else {
      print("there's no buffer")
      return
    }

    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let result = try mnist().prediction(image: pixelBuffer)
        print("result is \(result.classLabel), accuracy is \(result.output[result.classLabel])")
      } catch {
        print("failed to predict \(error)")
      }
    }

  }

  private func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
    let imageWidth = bounds.width
    let imageHeight = bounds.height

    // Begin with input rect.
    var rect = forRegionOfInterest

    // Reposition origin.
    rect.origin.x *= imageWidth
    rect.origin.x += bounds.origin.x
    rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y

    // Rescale normalized coordinates.
    rect.size.width *= imageWidth
    rect.size.height *= imageHeight

    return rect
  }

  private func shapeLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {
    // Create a new layer.
    let layer = CAShapeLayer()

    // Configure layer's appearance.
    layer.fillColor = nil // No fill to show boxed object
    layer.shadowOpacity = 0
    layer.shadowRadius = 0
    layer.borderWidth = 2

    // Vary the line color according to input.
    layer.borderColor = color.cgColor

    // Locate the layer.
    layer.anchorPoint = .zero
    layer.frame = frame
    layer.masksToBounds = true

    // Transform the layer to have same coordinate system as the imageView underneath it.
    layer.transform = CATransform3DMakeScale(1, -1, 1)

    return layer
  }

}

extension MainViewController {

  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    next?.touchesBegan(touches, with: event)
  }

}
