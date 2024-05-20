import SwiftUI

struct ProfileView: View {
    @State private var selectedSegment = 0
    let segments = ["Uthyrare", "Hyresgäst"]
    var body: some View {
        VStack{
            Picker("Select View", selection: $selectedSegment) {
                         ForEach(0..<segments.count) { index in
                             Text(segments[index])
                                 .tag(index)
                         }
                     }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedSegment == 0 {
                HomeOwnerView()
            } else {
                HomeGuestView()
            }
            Spacer()
        }
    }
}
struct HomeOwnerView : View {
    var body: some View {
        VStack{
            Image(systemName: "cat")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
//            Text("Boende")
//                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                .padding(.trailing, 250)
//            Text("Djur")
//                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                .padding(.trailing, 250)
        }
    }
}
struct HomeGuestView : View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}


#Preview {
    ProfileView()
}
