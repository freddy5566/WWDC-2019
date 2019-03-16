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

 # Chapter One -- Naive Comunication

 If jamfly wanna say something to charile, he attaches the message on the carrier pigeon's leg and send it to charile.
 charile can recieve it, everything seems to be great.

 */

//: Let's say something to charile
let message = "big brother is really bad"


//: Let's see what happened to the message that jamfly send to charile.
let frame = CGRect(x: 0, y: 0, width: 750, height: 650)
let view = HttpsView(frame: frame, message: message)
PlaygroundPage.current.liveView = view
//: It seems to be weird, charile recieve the wrong message

//: # Big brother is watching it.
//: ---
//: ***Who controls the past controls the future. Who controls the present controls the past.***

//: Big brother dont like people say something bad about him.
let sayHellooBigBrother = "big brother hello"
let saySomthingBadToBigBrother = "big brother is bad"
//: Let's see how big brother predict the sentence
ClassificationManager.shared.predictSentiment(from: sayHellooBigBrother)
ClassificationManager.shared.predictSentiment(from: saySomthingBadToBigBrother)

//: Big brother will detect the message if it's `negative`
//: Then it's time to control the future
//: It's really scary that message was changed, or even was seen.
//: But it is how `http` works.
//: It gives **big brother** chance to read/write the message.

/*:

 # Chapter two -- Secret code

 jamfly decide to encode the message that only charile know how to decrypt it.

 The rule is shifting each letter by 1 position.
 Say, hello world -> ifmmp xpsme

 We call it symmetric key cryptography, and the above method is known as the **Caesar cipher**

 Then, here is a question, what if jamfly and charile never meet before, they dont even know the encrypt algorithm and key.

 jamfly need to send a message to charile, tell him what's the algorithm and key.
 but it will very easy to leak.

 */

