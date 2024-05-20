import SwiftUI

struct SearchBarView: View {
    var body: some View {
        HStack {
            TextField("Sök stad", text: .constant(""))
                .padding(.leading, 10)
        }
        .padding(.top)
        .background(Color("background"))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
