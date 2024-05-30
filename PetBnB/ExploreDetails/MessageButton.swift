//
//  MessageButton.swift
//  PetBnB
//
//  Created by Jennet on 2024-05-30.
//

import SwiftUI

struct MessageButton: View {
    var home : Home
    @StateObject var chatViewModel = ChatViewModel()
    @State var conversationId: String?
    @State var navigateToChat : Bool = false
    
    var body: some View {
        Button(action: {
            if let userID = home.userID {
                chatViewModel.startConversation(with: userID) { conversationId in
                    if let conversationId = conversationId {
                        DispatchQueue.main.async {
                            self.conversationId = conversationId
                            // Navigate to ChatWindowView
                            // You can do this by setting a boolean flag to true,
                            // which will trigger NavigationLink
                            self.navigateToChat = true
                        }
                    }
                }
            }
        }, label: {
            Image(systemName: "message")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.gray)
                .padding()
                .offset(y: -50)
        })

        if let conversationId = conversationId {
                NavigationLink(destination: ChatWindowView(conversationId: conversationId), isActive: $navigateToChat) {
                    EmptyView()
                }
        }
    }
}

//#Preview {
//    MessageButton()
//}
