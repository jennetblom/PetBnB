
import Foundation
import SwiftUI
import FirebaseFirestore

struct ChatWindowView : View {
    
    @State var chatText = "Write something..."
 
    @State var messages = [
           Message(id: "0", senderID: "user1", receiverID: "user2", content: "Hejsan!", timestamp: Timestamp(date: Date())),
           Message(id: "1", senderID: "user2", receiverID: "user1", content: "Hej hur mår du?", timestamp: Timestamp(date: Date())),
           Message(id: "2", senderID: "user1", receiverID: "user2", content: "Jo jag mår bra tack! Hur e det med dig?", timestamp: Timestamp(date: Date())),
           Message(id: "3", senderID: "user2", receiverID: "user1", content: "Jo det e bra, ska ut i solen nu", timestamp: Timestamp(date: Date())),
           Message(id: "4", senderID: "user1", receiverID: "user2", content: "Vad härligt!", timestamp: Timestamp(date: Date()))
           ]
    
    var body : some View {
        VStack{
        messagesView
            
        Divider()
        chatBottomBar
    
           
        }.navigationTitle("Username")
            .navigationBarTitleDisplayMode(.inline)
    }
    var chatBottomBar : some View {
        
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 20))
                .foregroundColor(Color(.darkGray))
            TextEditor(text: $chatText)
                .frame(height: 40)
            Button {
                
            } label: {
                Text("Send")
                    .foregroundColor(.black)
            }.padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color("primary"))
                .cornerRadius(4)
            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    var messagesView: some View {
        ScrollView {
            ForEach(messages) { message in
                HStack {
                    if message.senderID == "user1" { // Assuming "user1" is the current user
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
}
 
struct MessageBubble: View {
    let message: String
    let color: Color
    let timestamp: Timestamp
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text(message)
                .padding()
                .background(color)
                .cornerRadius(8)
                .foregroundColor(.black)
        }
    }
}
#Preview {
    ChatWindowView()
}

