import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var senderID: String
    var receiverID: String
    var content: String
    var timestamp: Timestamp
    
    func formattedTimestamp(after previousMessage: Message?) -> String? {
        let calendar = Calendar.current
        let now = Date()
        let messageDate = timestamp.dateValue()
        
        let dateFormatter = DateFormatter()
        
        // Check for pause and return timestamp only if there was a pause
        if let previousMessage = previousMessage {
            let pauseThreshold: TimeInterval = 60 * 5 // 5 minutes (adjust as needed)
            let pauseDuration = messageDate.timeIntervalSince(previousMessage.timestamp.dateValue())
            if pauseDuration >= pauseThreshold {
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: messageDate)
            } else {
                return nil
            }
        }
        
        // Continue with date formatting based on other conditions
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
