//: [Previous](@previous)

import PlaygroundSupport
import Foundation
import UIKit

/*:

 # Chapter two -- Secret code

 jamfly decide to encode the message that only charile know how to decrypt it.

 The rule is shifting each letter by 1 position.
 Say, hello world -> ifmmp xpsme

 We call it symmetric key cryptography, and the above method is known as the **Caesar cipher**

 Then, here is a question, what if jamfly and charile never meet before, they dont even know the encrypt algorithm and key.

 jamfly need to send a message to charile, tell him what's the algorithm and key.
 but it means that big brother can read it also.

 */
//: Befor we start Let's see the result of caesar cipher

//: Now enter the message, shifted key
let messageYouWantToEncode = "Carry on,carry on,as if nothing really matters-"
let shiftedKey = 1

let caesarMessage = EncrytableMessage(message: messageYouWantToEncode,
                                      encrytableProtocol: .caesar(key: shiftedKey))
//: Now we are going to encode it, Let's see what's the result of it
let encodedString = caesarMessage.caesarEncode()

let encodedMessage = EncrytableMessage(message: encodedString,
                                       encrytableProtocol: .caesar(key: shiftedKey))
//: Now we need to decode it to see the original message
let originalMessage = encodedMessage.caesarDecode()

//: Now jamfly want to say somting to charile, but this time which is encoded
let jamflyCaesarMessage = EncrytableMessage(message: "big brother is geek",
                                            encrytableProtocol: .caesar(key: 1))

//: Let's see what happened to the message that jamfly send to charile.
//: Dont forget that big brother doesn't like people say somthing bad about him.
//: He also want to control the future

let frame = CGRect(x: 0, y: 0, width: 750, height: 650)
let jamflyCaesarView = HttpsView(frame: frame, message: jamflyCaesarMessage)
PlaygroundPage.current.liveView = jamflyCaesarView

//: [Next](@next)
