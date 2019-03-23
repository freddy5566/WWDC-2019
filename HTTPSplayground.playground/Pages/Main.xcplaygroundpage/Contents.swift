// by jamfly
// WWDC 2019
//

import PlaygroundSupport


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

//: Befor we start it. Let's see the result of caesar cipher
//:

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

/*:

 # Chapter three -- Carrying the boxes

 Cause jamfly and charile found out that their message often get altered,

 They decide to use a brand-new way to send message

 1. jamfly send a pigeon to charile without any message.
 2. charile recieve the pigeon back carrying a box with an open lock, but keeping the key.
 3. jamfly put the message in the box, closeds the locks and sends the box to charile.
 4. chariel recieve the box opens it with the key and reads the message.

 In this way, big brother cannot change the message by intercepting the pigeon.
 Because he doesn't have the key.

 This is commonly known as *asymmetric key cryptography*
 In technical speech the box is known as *public key*
 the key to open it is known as the *private key*

 But how does charile know the box was send by jamfly?
 if jamfly sign their signature to charile, this way charile can know that the box is send from jamfly

 But, the whole box can be replaceed in the way, so there's a famous, well known and trustworthy guy, Tim.

 Tim gave his signature to everyone and everybody trusts that he will only sign boxes for legitimate people.
 Tim will only sign an jamfly box if he’s sure that the one asking for the signature is charile.

 In this way, if big brother change the box, charile will know that box is fraud cause there's no Tim's signature.

 Tim is technical terms is commonly referred to as a *Certification Authority*

 jamfly and charile is happy cause they have a great to comunication, but pigeon won't like it.
 only one message, it has to fly more times.

 So, they decide that message is still using *Caesar cipher*(symmetric cryptography)
 and send the box(asymmetric cryptography) with Tim sined box to choose the key to encrypt it.

 In this way, they can get the message, and pigeon wont be angry bird.

 Now you know how *HTTPS* works.

 */


//: Let's say something to charile.
let message = EncrytableMessage(message: "big brother is really bad.")

//: Now jamfly want to encode the message this time.
let jamflyCaesarMessage = EncrytableMessage(message: "big brother is geek",
                                            encrytableProtocol: .caesar(key: 1))

//: You can decide if you want to encode ypur message.

//: Move pigeon to deliver message to charile.
//:
//: Let's see what happened to the message that jamfly send to charile.
//:
//: Be careful the big brother's TV, there's nothing can escape from it.

//: But most importantly Let's draw a pigeion for yourself to move.


let mainViewController = MainViewController(message: message)

PlaygroundPage.current.liveView = mainViewController.view
