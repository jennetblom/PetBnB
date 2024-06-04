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
    
    func formattedTimestamp() -> String {
        let calendar = Calendar.current
        let now = Date()
        let messageDate = timestamp.dateValue()
        
        let dateFormatter = DateFormatter()
        
        if calendar.isDateInToday(messageDate) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: messageDate)
        } else if calendar.isDate(messageDate, equalTo: now, toGranularity: .weekOfYear) {
                  dateFormatter.locale = Locale(identifier: "sv_SE")
                  dateFormatter.dateFormat = "EEEE"
                  let weekday = dateFormatter.string(from: messageDate)
                  return weekday.prefix(1).capitalized + weekday.dropFirst()
        } else {
            dateFormatter.locale = Locale(identifier: "sv_SE")
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: messageDate)
        }
        
    }
}
