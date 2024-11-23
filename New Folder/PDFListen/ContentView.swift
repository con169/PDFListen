import SwiftUI
import PDFKit
import AVFoundation
#if os(iOS)

class PDFViewModel: ObservableObject {
    @Published var pdfView = PDFView()
    private let pdfName: String?
    var pdfDocument: PDFDocument?
    
    init(pdfName: String? = nil) {
        self.pdfName = pdfName
        loadPDFDocument()
    }
    
    func loadPDFDocument() {
        if let pdfDocument = pdfDocument {
            configurePDFView(with: pdfDocument)
        }
        else {
            print("No PDF found or could not load document.")
        }
    }
    
    private func configurePDFView(with document: PDFDocument){
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.isUserInteractionEnabled = true
    }
    
    func goToPreviousPage() {
        guard let currentPage = pdfView.currentPage else { return }
        if let previousPage = pdfView.document?.page(at: pdfView.document!.index(for: currentPage) - 1) {
            pdfView.go(to: previousPage)
        }
    }

    func goToNextPage() {
        guard let currentPage = pdfView.currentPage else { return }
        if let nextPage = pdfView.document?.page(at: pdfView.document!.index(for: currentPage) + 1) {
            pdfView.go(to: nextPage)
        }
    }
}



struct FilePicker: UIViewControllerRepresentable {
    @Binding var pdfDocument: PDFDocument?
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        let parent: FilePicker
        
        init(_ parent: FilePicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                if let document = PDFDocument(url: url) {
                    parent.pdfDocument = document
                } else {
                    print("Failed to load PDF from the selected file. Please select a valid PDF file.")
                }
            } else {
                print("No document was selected.")
            }
        }
    }
}

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
