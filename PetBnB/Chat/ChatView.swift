import SwiftUI

struct ChatView: View {
    @State var isShowingChat = false
    var body: some View {
        VStack {
            Button("Chatconversation") {
                isShowingChat = true
            }.padding()
                .background(Color("primary"))
                .cornerRadius(15.0)
        }.sheet(isPresented: $isShowingChat) {
            NavigationView {
                ChatWindowView()
            }
        }
    }
}

#Preview {
    ChatView()
}
