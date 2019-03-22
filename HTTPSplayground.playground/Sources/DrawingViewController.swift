//
//  ClassificationManager.swift
//  WWDC 2019
//
//  Created by jamfly on 16/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import UIKit

final public class DrawingViewController: UIViewController {

  // MARK: - Properties

  private lazy var titleLabel: UILabel = {
    let frame = CGRect(x: 64,
                       y: 116,
                       width: view.frame.width,
                       height: 229)
    let titleLabel = UILabel(frame: frame)
    titleLabel.text = "Draw the pigeon to help you deliver message"
    return titleLabel
  }()

  private lazy var mainImageView: UIImageView = {
    let mainImageView = UIImageView(frame: view.frame)
    return mainImageView
  }()

  private lazy var tempImageView: UIImageView = {
    let tempImageView = UIImageView(frame: view.frame)
    return tempImageView
  }()

  private lazy var backgroundImageView: UIImageView = {
    let backgroundImage = UIImage(named: "tim_apple_ipad.png")
    let frame = CGRect(x: view.frame.minX + 150,
                       y: view.frame.minY,
                       width: view.frame.width,
                       height: view.frame.height)
    let backgroundImageView = UIImageView(frame: frame)
    backgroundImageView.image = backgroundImage
    backgroundImageView.contentMode = .scaleAspectFill
    return backgroundImageView
  }()

  private lazy var clearButton: UIButton = {
    let frame = CGRect(x: 50,
                       y: 50,
                       width: 100,
                       height: 50)
    let clearButton = UIButton(frame: frame)
    clearButton.setTitle("Clear", for: .normal)
    clearButton.addTarget(self,
                          action: #selector(clear),
                          for: .touchUpInside)
    return clearButton
  }()

  private lazy var finishedButton: UIButton = {
    let frame = CGRect(x: 200,
                       y: 50,
                       width: 100,
                       height: 50)
    let finishedButton = UIButton(frame: frame)
    finishedButton.setTitle("Done", for: .normal)
    finishedButton.addTarget(self,
                             action: #selector(finishedPressed),
                             for: .touchUpInside)
    return finishedButton
  }()

  private var lastPoint = CGPoint.zero
  private var color = UIColor.black
  private var brushWidth: CGFloat = 10.0
  private var opacity: CGFloat = 1.0
  private var swiped = false

  // MARK: - Initialization

  public init() {
    super.init(nibName: nil, bundle: nil)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("")
  }

  // MARK: - Life Cycle

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    view.addSubview(backgroundImageView)
    view.addSubview(mainImageView)
    view.addSubview(tempImageView)
    view.addSubview(clearButton)
    view.addSubview(finishedButton)
    view.addSubview(titleLabel)
  }

  // MARK: - Public Methods

  // MARK: - Private Methods

  private func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
    UIGraphicsBeginImageContext(view.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    tempImageView.image?.draw(in: view.bounds)

    context.move(to: fromPoint)
    context.addLine(to: toPoint)

    context.setLineCap(.round)
    context.setBlendMode(.normal)
    context.setLineWidth(brushWidth)
    context.setStrokeColor(color.cgColor)

    context.strokePath()

    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    tempImageView.alpha = opacity

    UIGraphicsEndImageContext()
  }

  @objc private func clear() {
    mainImageView.image = nil
  }

  @objc private func finishedPressed() {
    // get the documents directory url
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    // choose a name for your image
    let fileName = "drawing.jpg"
    // create the destination file url to save your image
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    // get your UIImage jpeg data representation and check if the destination file url already exists
    if let data = mainImageView.image!.jpegData(compressionQuality:  1.0) {
      do {
        // writes the image data to disk
        try data.write(to: fileURL)
        print("file saved")
      } catch {
        print("error saving file:", error)
      }
    }

  }

  // MARK: - Drawing

  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    swiped = false
    lastPoint = touch.location(in: view)
    print("start point is \(lastPoint)")
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    swiped = true
    let currentPoint = touch.location(in: view)
    drawLine(from: lastPoint, to: currentPoint)

    lastPoint = currentPoint
  }

  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !swiped {
      // draw a single point
      drawLine(from: lastPoint, to: lastPoint)
    }

    // Merge tempImageView into mainImageView
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
    tempImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    tempImageView.image = nil
    print("end point is \(touches.first?.location(in: view))")
  }

}

