//: [Previous](@previous)

import PlaygroundSupport
import UIKit

let vc = DrawingViewController()

let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
if let dirPath          = paths.first
{
  let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("drawing.jpg")
  let url = URL(fileURLWithPath: imageURL.path)
//  FileManager.default.removeItem(at: url)
  let image    = UIImage(contentsOfFile: imageURL.path)
  print(image)
}

PlaygroundPage.current.liveView = vc.view

//: [Next](@next)
