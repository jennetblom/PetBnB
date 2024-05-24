import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Sök stad", text: $searchText)
                .padding(.leading, 10)
                .foregroundColor(Color("text"))
        }
        .padding(.vertical, 10)
        .background(Color(UIColor.lightGray.withAlphaComponent(0.3)))
        .cornerRadius(8)
        .padding(.horizontal, 20)
        
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
