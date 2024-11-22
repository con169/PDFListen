import SwiftUI

@main
struct PDFListenApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            ContentView()
            #else
            // Provide a fallback or placeholder view for non-iOS platforms
            Text("This app is currently supported only on iOS.")
            #endif
        }
    }
}
