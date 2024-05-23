import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Sök stad", text: $searchText)
                .padding(.leading, 10)
        }
        .padding(.top)
        .background(Color("background"))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
