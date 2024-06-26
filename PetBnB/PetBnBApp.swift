
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct PetBnBApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var exploreViewModel = ExploreViewModel()
    @StateObject private var tabViewModel = TabViewModel()
    @StateObject private var chatViewModel = ChatViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(chatViewModel: chatViewModel)
                .environmentObject(exploreViewModel)
                .environmentObject(tabViewModel)
                .environmentObject(chatViewModel)
        }
    }
}
