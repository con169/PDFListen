import SwiftUI
import PDFKit
// FilePicker.swift
// Provides a UIKit-based file picker for selecting PDF documents.
//
// This component uses `UIDocumentPickerViewController` to allow users to select a PDF file from their device.
// The selected file is then loaded into the app for viewing.
//
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
