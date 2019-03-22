//
//  DrawableViewController.swift
//  WWDC 2019
//
//  Created by jamfly on 22/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//


import UIKit

public class DrawableViewController: UIViewController {

  // MARK: - Properties

  var color = UIColor.black
  var opacity: CGFloat = 1.0

  lazy var mainImageView: UIImageView = {
    let mainImageView = UIImageView(frame: view.frame)
    return mainImageView
  }()

  lazy var tempImageView: UIImageView = {
    let tempImageView = UIImageView(frame: view.frame)
    return tempImageView
  }()

  lazy var backgroundImageView: UIImageView = {
    let frame = CGRect(x: view.frame.minX + 150,
                       y: view.frame.minY,
                       width: view.frame.width,
                       height: view.frame.height)
    let backgroundImageView = UIImageView(frame: frame)
    backgroundImageView.contentMode = .scaleAspectFill
    return backgroundImageView
  }()

  private var lastPoint = CGPoint.zero
  private var brushWidth: CGFloat = 10.0
  private var swiped = false
  // MARK: - Life Cycle

  public override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.white

    view.addSubview(backgroundImageView)
    view.addSubview(tempImageView)
    view.addSubview(mainImageView)
  }

  // MARK: - Drawing

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

  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    next?.touchesBegan(touches, with: event)
    guard let touch = touches.first else {
      return
    }
    swiped = false
    lastPoint = touch.location(in: view)
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    guard let touch = touches.first else {
      return
    }
    swiped = true
    let currentPoint = touch.location(in: view)
    drawLine(from: lastPoint, to: currentPoint)

    lastPoint = currentPoint
  }

  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    if !swiped {
      // draw a single point
      drawLine(from: lastPoint, to: lastPoint)
    }
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
    tempImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    tempImageView.image = nil
  }

}
