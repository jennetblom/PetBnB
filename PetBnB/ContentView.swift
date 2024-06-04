import SwiftUI
import Firebase

struct ContentView: View {
    let db = Firestore.firestore()
    @State var signedIn = false
    @State var userID: String?
    
    var body: some View {
        if !signedIn {
            LogInView(signedIn: $signedIn)
        } else if let userID = userID {
            MainTabView(userID: userID)
        } else {
            Text("Loading...")
                .onAppear {
                    if let user = Auth.auth().currentUser {
                        self.userID = user.uid
                        self.signedIn = true
                    }
                }
        }
    }
}

struct MainTabView: View {
    var userID: String
    @EnvironmentObject var tabViewModel: TabViewModel

    var body: some View {
            TabView(selection: $tabViewModel.selectedTab) {
                ExploreView()
                    .tabItem {
                        Label("Utforska", systemImage: "magnifyingglass")
                    }
                    .tag(0)
                FavoritesView()
                    .tabItem {
                        Label("Favoriter", systemImage: "heart")
                    }
                    .tag(1)
                ChatView()
                    .tabItem {
                        Label("Chatt", systemImage: "message")
                    }
                    .tag(2)
                ProfileView(userID: userID)
                    .tabItem {
                        Label("Profil", systemImage: "person")
                    }
                    .tag(3)
            }
            .onChange(of: tabViewModel.selectedTab) { _ in
                tabViewModel.isAddHomePresented = false
            }
            .accentColor(Color("secondary"))
        }
    }

#Preview {
    ContentView()
}
