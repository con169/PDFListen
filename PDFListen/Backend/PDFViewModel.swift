import SwiftUI
import PDFKit
// PDFViewModel.swift
// Manages loading, viewing, and navigating through PDF documents.

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
