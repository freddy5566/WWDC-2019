import Foundation
import AVFoundation

struct SpeakManager {

  static var shared = SpeakManager()

  private let synthesizer = AVSpeechSynthesizer()
  private let voice = AVSpeechSynthesisVoice(language: "en-US")

  func writeDownYearOfWWDC() {
    let string = "even though we cannot predict what's the next product to launch, but we do know what's year of WWDC. I guess it's 2019, why dnot you write down your answer in the brand new ipad mini"
    speak(string)
  }

  func drawPigeon() {
    let string = "Draw a pigeon to deliver jamfly's message"
    speak(string)
  }

  func dragThePigeion() {
    let string = "Now drag the pigeon you drawed to deliver message for you, but be careful the content of message when charlie recieve it."
    speak(string)
  }

  func bigBrotherFound() {
    let string = "found you!!!!!! Nothing can escape from my TV!"
    speak(string)
  }

  func getSign() {
    let string = "Congratulations you got the sign, Now drag pigeon to get message"
    speak(string)
  }

  func recieveMessage() {
    let string = "charlie recieve the message"
    speak(string)
  }

  func getMessage() {
    let string = "Now darg the pigeon to deliver the message to see what will happen."
    speak(string)
  }

  func speak(_ string: String) {
    let utterance = AVSpeechUtterance(string: string)
    synthesizer.speak(utterance)
  }

}
