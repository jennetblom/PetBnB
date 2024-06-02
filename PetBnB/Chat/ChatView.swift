import SwiftUI
import FirebaseAuth
import Combine

struct ChatView: View {
    
    @StateObject var viewModel = ChatViewModel()
    @State var selectedConversationId: String?
    var auth = Auth.auth()
//    @State var user : User?
    @State var isFetchingConversations = true
    
    var body: some View {
        VStack {
            HeaderView (viewModel: viewModel)
            Divider()
            
            if isFetchingConversations {
                ProgressView()
            } else {
                MessageRowView(viewModel: viewModel,selectedConversationId: $selectedConversationId)
            }
            
            Divider()
        } .onAppear {
            viewModel.fetchConversations {
                isFetchingConversations = false
            }
             
        }
    }
}
struct HeaderView : View {
    @ObservedObject var viewModel: ChatViewModel
    var body: some View {
        HStack {
            if let profilePictureURL = viewModel.currentUser?.profilePicture {
                AsyncImage(url: profilePictureURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 45, height: 45)
                            .cornerRadius(22.5)
                            .overlay(Circle().stroke(Color.black, lineWidth: 0.5))
                    case .failure:
                        Image("catimage")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .cornerRadius(22.5)
                            .overlay(Circle().stroke(Color.black, lineWidth: 0.5))
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image("catimage")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .cornerRadius(22.5)
                    .overlay(Circle().stroke(Color.black, lineWidth: 0.5))
            }
            
            
            VStack(alignment: .leading, spacing: 4) {
                if let currentUser = viewModel.currentUser {
                    Text(currentUser.name)
                        .font(.system(size: 16, weight: .bold))
                } else {
                    Text("Loading...")
                        .font(.system(size: 16, weight: .bold))
                }
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
        }.onAppear {
            viewModel.fetchUser(withID: viewModel.auth.currentUser?.uid ?? "") {
                // Update UI when user data is fetched
            }
        }
        .padding()
    }
}
struct MessageRowView: View {
    @ObservedObject var viewModel: ChatViewModel
    @Binding var selectedConversationId: String?
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.conversations) { conversation in
                NavigationLink(destination: ChatWindowView(conversationId: conversation.id ?? "")) {
                    VStack {
                        HStack(spacing: 16){
                            if let otherUserId = conversation.participants.first(where: { $0 != Auth.auth().currentUser?.uid }) {
                                if let userProfilePictureURL = viewModel.getUserProfilePicture(for: otherUserId) {
                                    AsyncImage(url: userProfilePictureURL) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(25)
                                                .overlay(Circle().stroke(Color.black,lineWidth: 0.5))
                                        case .failure:
                                            Image("catimage")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(25)
                                                .overlay(Circle().stroke(Color.black,lineWidth: 0.5))
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    Image("catimage")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(25)
                                        .overlay(Circle().stroke(Color.black,lineWidth: 0.5))
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(viewModel.getUserName(for: otherUserId))
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                    Text(conversation.lastMessage)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.lightGray))
                                }
                                Spacer()
                                Text("22d")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.black)
                            }
                        }
                        Divider()
                            .padding(.vertical, 8)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            // Fetch user data for each conversation
            for conversation in viewModel.conversations {
                if let otherUserId = conversation.participants.first(where: { $0 != Auth.auth().currentUser?.uid }) {
                    viewModel.fetchUser(withID: otherUserId)
                }
            }
        }
    }
}
#Preview {
    ChatView()
}


