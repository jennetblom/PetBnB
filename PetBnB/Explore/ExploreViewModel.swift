import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    @Published var homes = [Home]()
    private var db = Firestore.firestore()

    init() {
        fetchHomes()
    }

    func fetchHomes() {
           db.collection("homes").getDocuments { (querySnapshot, error) in
               if let error = error {
                   print("Error getting documents: \(error.localizedDescription)")
               } else {
                   if let querySnapshot = querySnapshot {
                       for document in querySnapshot.documents {
                           print("Raw document data: \(document.data())")
                       }
                       
                       self.homes = querySnapshot.documents.compactMap { document in
                           do {
                               let home = try document.data(as: Home.self)
                               print("Successfully fetched home: \(home)")
                               return home
                           } catch {
                               print("Error decoding home: \(error)")
                               return nil
                           }
                       }
                       print("Fetched homes: \(self.homes)")
                   }
               }
           }
       }
}
