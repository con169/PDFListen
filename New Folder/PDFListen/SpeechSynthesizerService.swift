import AVFoundation

class SpeechSynthesizerService {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        synthesizer.speak(utterance)
    }

    func pause() {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
        }
    }

    func resume() {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
        }
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

    // Additional helper methods can be added if needed, like checking current state
    func isSpeaking() -> Bool {
        return synthesizer.isSpeaking
    }

    func isPaused() -> Bool {
        return synthesizer.isPaused
    }
}
