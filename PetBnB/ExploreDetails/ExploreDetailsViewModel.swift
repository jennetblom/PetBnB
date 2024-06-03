import Foundation
import Combine
import FirebaseFirestore

class ExploreDetailsViewModel: ObservableObject {
    @Published var user: User?
    private var cancellables = Set<AnyCancellable>()
    private let firestoreUtils = FirestoreUtils()
    
    func fetchUser(by userID: String) {
        firestoreUtils.fetchUser(by: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                case .failure(let error):
                    print("Error fetching user: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func randomAnimalSentence(for animalInfo: AnimalInfo) -> String {
        let sentences = [
            "Boendet har en \(animalInfo.type.lowercased()) som är \(animalInfo.age) år.",
            "\(animalInfo.type.capitalized) på boendet är \(animalInfo.age) år gammal.",
            "Det finns en \(animalInfo.type.lowercased()) på boendet som är \(animalInfo.age) år.",
            "Boendet hyser en \(animalInfo.type.lowercased()) som är \(animalInfo.age) år gammal.",
            "En \(animalInfo.type.lowercased()) på boendet är \(animalInfo.age) år."
        ]
        return sentences.randomElement()!
    }

    func animalSummary(for home: Home) -> String {
        var animalCounts: [String: Int] = [:]
        
        for animal in home.animals.values {
            animalCounts[animal.type, default: 0] += 1
        }
        
        let descriptions = animalCounts.map { "\($0.value) \($0.key.lowercased())\($0.value > 1 ? pluralForm(for: $0.key) : "")" }
        
        if descriptions.count > 2 {
            let allButLast = descriptions.dropLast().joined(separator: ", ")
            let last = descriptions.last!
            return "Boendet har " + allButLast + " och " + last + "."
        } else {
            return "Boendet har " + descriptions.joined(separator: " och ") + "."
        }
    }

    private func pluralForm(for type: String) -> String {
        switch type.lowercased() {
        case "hund":
            return "ar"
        case "fisk":
            return "ar"
        case "reptil":
            return "er"
        case "pälsdjur":
            return ""
        case "katt":
            return "er"
        case "fågel":
            return "ar"
        default:
            return ""
        }
    }
}
