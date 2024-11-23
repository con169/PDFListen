import SwiftUI
import AVFoundation

struct TextToSpeechControls: View {
    let speechService: SpeechSynthesizerService

    var body: some View {
        HStack {
            Button("Pause") {
                speechService.pause()
                }
            
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Button("Resume") {
                speechService.resume()
                }
            
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Button("Stop") {
                speechService.stop()
                }
            
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
    }
}
