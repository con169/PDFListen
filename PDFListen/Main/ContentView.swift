import SwiftUI
import PDFKit
import AVFoundation

//files



#if os(iOS)

struct ContentView: View {
    @StateObject private var pdfViewModel = PDFViewModel(pdfName: "sample")
    private let speechService = SpeechSynthesizerService()
    @State private var pdfDocument: PDFDocument? = nil
    @State private var showFilePicker = false
    @State private var showControls = false

    var body: some View {
        ZStack {
            PDFViewDisplay(pdfView: $pdfViewModel.pdfView)
                .onTapGesture {
                    withAnimation {
                        showControls.toggle()
                    }
                }
            
            if showControls {
                VStack {
                    Spacer()
                    PageNavigationControls(
                        goToPreviousPage: pdfViewModel.goToPreviousPage,
                        goToNextPage: pdfViewModel.goToNextPage
                    )

                    TextToSpeechControls(speechService: speechService)
                        
                    .padding()

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

                    Button("Choose PDF File") {
                        showFilePicker.toggle()
                    }
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .sheet(isPresented: $showFilePicker) {
                        FilePicker(pdfDocument: $pdfDocument)
                    }
                    .onChange(of: pdfDocument) { newDocument in
                        if let newDocument = newDocument {
                            pdfViewModel.pdfDocument = newDocument
                            pdfViewModel.loadPDFDocument()
                        }
                    }
                }
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                .padding()
            }
        }
    }

    func readPDFContent() {
        if let currentPage = pdfViewModel.pdfView.currentPage,
           let pageText = currentPage.string {
            speechService.speak(pageText)
        } else {
            print("No text found on the current page.")
        }
    }
}


#Preview {
    ContentView()
}
#endif
