//: [Previous](@previous)

import PlaygroundSupport
import Foundation
import UIKit

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

//: Now let's see how this works
let message = EncrytableMessage(message: "hello WWDC 2019",
                                encrytableProtocol: .caesar(key: 8))
let frame = CGRect(x: 0, y: 0, width: 750, height: 650)
let view = HttpsView(frame: frame,
                     message: message)
PlaygroundPage.current.liveView = view
