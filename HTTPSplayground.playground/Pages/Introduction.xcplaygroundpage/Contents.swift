// by jamfly
// WWDC 2019
//

import PlaygroundSupport
import SpriteKit
import NaturalLanguage
import CoreML

/*:
 # The Story of HTTPS

 [HTTPS](https://en.wikipedia.org/wiki/HTTPS) is an extension of the Hypertext Transfer Protocol (HTTP). It is used for secure communication over a computer network, and is widely used on the Internet.

 ----

 # Prologue

 All the activity of internet is about the servers. And here I'm going to introduce the basic concept of HTTPS via the story.

 In here pigeon represents the communication between servers, and jamfly & charile represents the sever.

 # Chapter One -- Naive Communication

 If jamfly wanna say something to charile, he attaches the message on the carrier pigeon's leg and send it to charile.
 charile can recieve it, everything seems to be great.

 */

//: Let's say something to charile
let message = EncrytableMessage(message: "big brother is really bad.")

//: Move pigeon to deliver message to charile.
//:
//: Let's see what happened to the message that jamfly send to charile.
//:
//: But be careful the big brother's TV, there's nothing can escape from it.
let frame = CGRect(x: 0, y: 0, width: 750, height: 650)
var view = HttpView(frame: frame, message: message)
PlaygroundPage.current.liveView = view

//: It seems to be weird, charile recieve the wrong message.

//: # Big brother is watching it.
//:
//: ***Who controls the past controls the future. Who controls the present controls the past. ― George Orwell, 1984***
//:
//: Big brother doesn't like people say something bad about him.
let sayHellooBigBrother = "big brother hello"
let saySomthingBadToBigBrother = "big brother is bad"

//: Let's see how big brother predicts the sentence
ClassificationManager.shared.predictSentiment(from: sayHellooBigBrother)
ClassificationManager.shared.predictSentiment(from: saySomthingBadToBigBrother)

//: Big brother will detect the message if it's `negative`
//:
//: Then it's time to control the future.
//:
//: It's really scary that message was changed, or even was seen directly.
//:
//: But it is how `http` works.
//:
//: It gives not only **big brother** but everyone the chance to *read*/*rewrite* the message.

//: [Next](@next)
