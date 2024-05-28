import SwiftUI

struct AdditionalInfoView: View {
    var additionalInfo: String
    
    var body: some View {
            Section(header: Text("Mer info")) {
                VStack(alignment: .leading, spacing: 8) {
                Text(additionalInfo)
            }
        }
        .padding(.horizontal)
    }
}
