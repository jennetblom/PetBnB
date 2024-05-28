import SwiftUI

struct ChatView: View {

    var body: some View {
        VStack {
            HeaderView ()
            Divider()
            MessageRowView()
            Divider()
        }
    }
}
struct MessageRowView: View {
    var body: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                NavigationLink(destination: ChatWindowView() ) {
                    VStack {
                        HStack(spacing: 16){
                            Image("catimage")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(44)
                                .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color.black,lineWidth: 0.5))
                            VStack(alignment: .leading) {
                                Text("Username")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                                Text("Message sent to user")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                            }
                            Spacer()
                            Text("22d")
                                .font(.system(size: 14, weight: .regular))
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
                    .font(.system(size: 20, weight: .bold))
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 12, height: 12)
                    Text("Online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
        }
        .padding()
    }
}
