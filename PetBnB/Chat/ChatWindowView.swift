
import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatWindowView : View {
    
    @State var chatText = ""
    @StateObject var viewModel: ChatWindowViewModel
    var conversationId : String

    init(conversationId: String) {
        self.conversationId = conversationId
                self._viewModel = StateObject(wrappedValue: ChatWindowViewModel(conversationId: conversationId))
      }
    var body : some View {
        VStack{
        Divider()
        messagesView
        
        chatBottomBar
            Divider()
        }
        .navigationTitle(viewModel.otherUser?.name ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchMessages()
            }
            
    }

    var messagesView: some View {
        ScrollView {
            ForEach(viewModel.messages) { message in
                HStack {
                    if message.senderID == Auth.auth().currentUser?.uid { // Assuming "user1" is the current user
                        Spacer()
                        MessageBubble(message: message.content, color: Color("primary"), timestamp: message.timestamp)
                    } else {
                        Image("catimage")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(44)
                            .overlay(RoundedRectangle(cornerRadius : 44).stroke(Color.black, lineWidth: 0.5))
                        MessageBubble(message: message.content, color: Color.gray.opacity(0.1), timestamp: message.timestamp)
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            Spacer()
        }
    }
    var chatBottomBar: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .leading) {
               
                TextEditor(text: $chatText)
                    .frame(height: 50)
                    .padding(.leading, 4)
                    .fontWeight(.light) // Adjust as needed
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 0.3)
                    )
                if chatText.isEmpty {
                    Text("Write something...")
                        .foregroundColor(.gray)
                        .padding(.leading, 4)
                        .offset(x: 5, y: -10)
                }
            }
            
            Button {
                // Handle send action
                viewModel.sendMessage(chatText)
                chatText = ""
            } label: {
                Text("Send")
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color("primary"))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
 
struct MessageBubble: View {
    let message: String
    let color: Color
    let timestamp: Timestamp
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text(message)
                .font(.system(size: 16))
                .padding(8)
                .background(color)
                .cornerRadius(8)
                .foregroundColor(.black)
        }
    }
}
//#Preview {
//    ChatWindowView()
//}

