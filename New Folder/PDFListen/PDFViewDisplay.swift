import SwiftUI
import PDFKit

struct PDFViewDisplay: View {
    @Binding var pdfView: PDFView

    var body: some View {
        PDFKitContainer(pdfView: $pdfView)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PDFKitContainer: UIViewRepresentable {
    @Binding var pdfView: PDFView
    
    func makeUIView(context: Context) -> PDFView {
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
    
    }
}
