//
//  MessageButton.swift
//  PetBnB
//
//  Created by Jennet on 2024-05-30.
//

import SwiftUI

struct MessageButton: View {
    @Binding var isChatActive: Bool
    @Binding var conversationId: String?
    var home: Home
    var chatViewModel: ChatViewModel
//    var otherUser: User

    var body: some View {
        NavigationLink(destination: ChatWindowView(conversationId: $conversationId.wrappedValue ?? ""), isActive: $isChatActive) {
                 Image(systemName: "message")
                     .foregroundColor(.gray)
                     .onTapGesture {
                         if let userID = home.userID {
                             chatViewModel.startConversation(with: userID) { conversationId in
                                 if let conversationId = conversationId {
                                     self.isChatActive = true
                                     self.conversationId = conversationId
                                 }
                             }
                         }
                     }
             }
         }
}
//#Preview {
//    MessageButton()
//}
