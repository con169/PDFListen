import SwiftUI
import PDFKit
import AVFoundation
#if os(iOS)
struct PDFKitView: UIViewRepresentable {
    let pdfDocument: PDFDocument?
    
    init(pdfName: String) {
        if let path = Bundle.main.url(forResource: pdfName, withExtension: "pdf") {
            self.pdfDocument = PDFDocument(url: path)
        } else {
            self.pdfDocument = nil
        }
    }
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.isUserInteractionEnabled = true
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = pdfDocument
    }
}

struct ContentView: View {
    let synthesizer = AVSpeechSynthesizer()
    
    func readPDFContent() {
        if let path = Bundle.main.url(forResource: "sample", withExtension: "pdf"),
           let pdfDocument = PDFDocument(url: path),
           let page = pdfDocument.page(at: 0),
           let pageText = page.string {
            let utterance = AVSpeechUtterance(string: pageText)
            synthesizer.speak(utterance)
        }
        else {
            print("No PDF found or could not read text.")
        }
    }
    
    var body: some View {
        VStack {
            PDFKitView(pdfName: "sample")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            Button("Pause") {
                if synthesizer.isSpeaking {
                    synthesizer.pauseSpeaking(at: .immediate)
                }
            }
            Button("Resume") {
                if synthesizer.isPaused {
                    synthesizer.continueSpeaking()
                }
            }
            Button("Stop") {
                if synthesizer.isSpeaking {
                    synthesizer.stopSpeaking(at: .immediate)
                }
            }
            Button(action: {
                readPDFContent()
            }) {
                Text("Read PDF Aloud")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        
    }
}

#Preview {
    ContentView()
}
#endif
