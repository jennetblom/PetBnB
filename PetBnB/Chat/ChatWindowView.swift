
import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatWindowView : View {
    
    @State var chatText = ""
    @StateObject var viewModel: ChatWindowViewModel
    var conversationId : String
    @EnvironmentObject var tabViewModel: TabViewModel
    @Environment(\.presentationMode) var presentationMode

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
            
            .onDisappear {
                if !tabViewModel.isChatWindowPresented {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        
    }

    var messagesView: some View {
        ScrollView {
            ForEach(viewModel.messages.indices, id: \.self) { index in
                let message = viewModel.messages[index]
                let previousMessage: Message? = index > 0 ? viewModel.messages[index - 1] : nil
                
                if let formattedTimestamp = message.formattedTimestamp(after: previousMessage) {
                    Text(formattedTimestamp)
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.8))
                        .offset(y: 10)
                }
                HStack {
                    if message.senderID == Auth.auth().currentUser?.uid { // Assuming "user1" is the current user
                        Spacer()
                        MessageBubble(message: message.content, color: Color("primary"), timestamp: message.timestamp)
                    } else {
                        NavigationLink(destination: ProfileView(userID: viewModel.otherUser?.id ?? "",
                                                                isEditable: false)) {
                            ProfileImageView(url: viewModel.otherUser?.profilePictureUrl, width: 40, height: 40)
                        }
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
                    .fontWeight(.light) 
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 0.3)
                    )
                if chatText.isEmpty {
                    Text("Skriv något...")
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
                Text("Skicka")
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

