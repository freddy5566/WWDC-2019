//
//  ClassificationManager.swift
//  WWDC 2019
//
//  Created by jamfly on 16/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import UIKit

final public class DrawingViewController: UIViewController {

  // MARK: - Properties

  private lazy var mainImageView: UIImageView = {
    let mainImageView = UIImageView(frame: view.frame)
    return mainImageView
  }()

  private lazy var tempImageView: UIImageView = {
    let tempImageView = UIImageView(frame: view.frame)
    return tempImageView
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
    view.addSubview(mainImageView)
    view.addSubview(tempImageView)
  }

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

  // MARK: - Drawing

  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    swiped = false
    lastPoint = touch.location(in: view)
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
  }

}

