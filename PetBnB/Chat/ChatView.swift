import SwiftUI
import FirebaseAuth

struct ChatView: View {

    @StateObject var viewModel = ChatViewModel()
    @State var selectedConversationId: String?
    var auth = Auth.auth()
    @State var user : User?
    @State var isFetchingConversations = true

    var body: some View {
        VStack {
            HeaderView ()
            Divider()
            
            if isFetchingConversations {
                ProgressView()
            } else {
                MessageRowView(viewModel: viewModel,selectedConversationId: $selectedConversationId)
            }
           
            Divider()
        }.onAppear {
            viewModel.fetchConversations {
                isFetchingConversations = false
            }
    }
    }
}
struct HeaderView : View {
    var body: some View {
        HStack {
            Image("catimage")
                .resizable()
                .frame(width: 45, height: 45)
                .cornerRadius(44)
                .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color.black,lineWidth: 0.5))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Username")
                    .font(.system(size: 16, weight: .bold))
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 12, height: 12)
                    Text("Online")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
        }
        .padding()
    }
}
struct MessageRowView: View {
    @ObservedObject var viewModel : ChatViewModel
    @Binding var selectedConversationId: String?
    var body: some View {
        ScrollView {
            ForEach(viewModel.conversations) { conversation in
                NavigationLink(destination: ChatWindowView(conversationId: conversation.id ?? "") ) {
                    VStack {
                        HStack(spacing: 16){
                            Image("catimage")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(44)
                                .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color.black,lineWidth: 0.5))
                            VStack(alignment: .leading) {
                                Text("Username")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                Text("Message sent to user")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                            }
                            Spacer()
                            Text("22d")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.black)
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
#Preview {
    ChatView()
}


