//
//  DrawingViewController.swift
//  WWDC 2019
//
//  Created by jamfly on 16/03/2019.
//  Copyright © 2019 jamfly. All rights reserved.
//

import Foundation
import UIKit

public class DrawingViewController: DrawableViewController {

  // MARK: - Properties

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

  private let pencileColors = [
    "Black",
    "Grey",
    "Red",
    "Blue",
    "LightBlue",
    "DarkGreen",
    "LightGreen",
    "Brown",
    "DarkOrange",
    "Yellow",
    "Eraser"
  ]
  
  private var penciles: [UIButton] = []

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

    view.addSubview(clearButton)
    view.addSubview(finishedButton)
    setUpPenciles()
  }

  // MARK: - Public Methods

  // MARK: - Private Methods

  @objc
  private func clear() {
    DispatchQueue.main.async { [weak self] in
      self?.mainImageView.image = nil
    }
  }

  @objc
  private func finishedPressed() {

  }

  @objc
  private func selectPencile(_ sender: UIButton) {
    print(penciles.index(of: sender))
    guard let index = penciles.index(of: sender), let pencil = Pencil(tag: index) else { return }
    color = pencil.color
    if pencil == .eraser {
      opacity = 1
    }

  }

  private func setUpPenciles() {
    for i in 0..<pencileColors.count {
      let frame = CGRect(x: 30 * Int(i),
                         y: 650,
                         width: 30,
                         height: 100)
      let button = UIButton(frame: frame)
      penciles.append(button)
      let color = UIImage(named: pencileColors[i])
      button.setImage(color, for: .normal)
      button.addTarget(self,
                       action: #selector(selectPencile(_:)),
                       for: .touchUpInside)
      view.addSubview(button)
    }
  }

}
