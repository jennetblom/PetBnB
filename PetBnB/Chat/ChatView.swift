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
            if let profilePictureURL = viewModel.currentUser?.profilePictureUrl {
                ProfileImageView(url: viewModel.currentUser?.profilePictureUrl, width: 45, height: 45)
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
                if let otherUserId = conversation.participants.first(where: { $0 != Auth.auth().currentUser?.uid }) {
                    NavigationLink(destination: ChatWindowView(conversationId: conversation.id ?? "")) {
                        VStack {
                            HStack(spacing: 16){
                                NavigationLink(destination: ProfileView(userID: otherUserId,
                                                                        isEditable: false)) {
                                    ProfileImageView(url: viewModel.getUserProfilePicture(for: otherUserId), width: 50, height: 50)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(viewModel.getUserName(for: otherUserId))
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    
                                    if conversation.lastMessageSenderId == Auth.auth().currentUser?.uid {
                                        Text("Du: \(conversation.lastMessage)")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(.lightGray))
                                    } else {
                                        Text(conversation.lastMessage)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(.lightGray))
                                    }
                                }
                                Spacer()
                                Text(conversation.formattedTimestamp())
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.black)
                                
                                // Badge for unread messages
                                if let unreadCount = conversation.unreadMessagesCount?[Auth.auth().currentUser?.uid ?? ""] {
                                    if unreadCount > 0 {
                                        ZStack {
                                            Circle()
                                                .foregroundColor(.red)
                                                .frame(width: 20, height: 20)
                                            
                                            Text("\(unreadCount)")
                                                .font(.system(size: 12))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
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
struct ProfileImageView: View {
    let url: URL?
    var width : CGFloat
    var height: CGFloat
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: width, height: height)
                        .cornerRadius(25)
                        .overlay(Circle().stroke(Color.black, lineWidth: 0.5))
                case .failure:
                    defaultImage
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            defaultImage
        }
    }
    
    private var defaultImage: some View {
        Image("catimage")
            .resizable()
            .frame(width: width, height: height)
            .cornerRadius(25)
            .overlay(Circle().stroke(Color.black, lineWidth: 0.5))
    }
}
#Preview {
    ChatView()
}


