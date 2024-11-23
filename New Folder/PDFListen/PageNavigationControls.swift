import SwiftUI

struct PageNavigationControls: View {
    let goToPreviousPage: () -> Void
    let goToNextPage: () -> Void

    var body: some View {
        HStack {
            Button(action: goToPreviousPage) {
                Label("Previous Page", systemImage: "arrow.left")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            Button(action: goToNextPage) {
                Label("Next Page", systemImage: "arrow.right")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
    }
}
