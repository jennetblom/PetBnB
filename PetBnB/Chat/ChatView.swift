import SwiftUI

struct ChatView: View {
    @State var isShowingChat = false
    var body: some View {
        NavigationView {
                   VStack {
                       NavigationLink(destination: ChatWindowView()) {
                           Text("Chatconversation")
                               .padding()
                               .background(Color("primary"))
                               .cornerRadius(15.0)
                               .foregroundColor(.white) // Gör texten vit
                       }
                   }
                   .navigationTitle("Chat")
               }
           }
}

#Preview {
    ChatView()
}
