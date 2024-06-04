//
//  Conversation.swift
//  PetBnB
//
//  Created by Jennet on 2024-05-29.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Conversation : Identifiable, Codable {
    @DocumentID var id : String?
    var participants: [String]
    var lastMessage : String
    var lastMessageSenderId : String
    var timestamp : Timestamp
}
