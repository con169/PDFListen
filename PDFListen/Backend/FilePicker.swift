import SwiftUI
import PDFKit
import CoreData

// FilePicker.swift
// Provides a UIKit-based file picker for selecting PDF documents.
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
                // Start accessing security-scoped resource
                if url.startAccessingSecurityScopedResource() {
                    defer { url.stopAccessingSecurityScopedResource() } // Ensure we stop accessing after we're done

                    do {
                        // Get the app's document directory
                        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let targetURL = documentDirectory.appendingPathComponent(url.lastPathComponent)

                        // Copy the file from the picked location to the app's directory
                        if FileManager.default.fileExists(atPath: targetURL.path) {
                            try FileManager.default.removeItem(at: targetURL) // Remove old file if it exists
                        }
                        try FileManager.default.copyItem(at: url, to: targetURL)

                        // Now use the copied file
                        if let document = PDFDocument(url: targetURL) {
                            print("Successfully loaded PDF from copied file: \(targetURL)")
                            parent.pdfDocument = document

                            // Save the PDF metadata to Core Data using CoreDataManager
                            CoreDataManager.shared.savePDFMetadata(url: targetURL)
                        } else {
                            print("Failed to load PDF from the copied file.")
                        }
                    } catch {
                        print("Error copying file: \(error)")
                    }
                } else {
                    print("Failed to access security-scoped resource.")
                }
            } else {
                print("No document was selected.")
            }
        }
    }
}
