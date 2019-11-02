import Foundation

struct Note {
    let uid: String
    let position: Int
    let content: String
    let importance: Importance
    let expirationDate: Date
    let category: Category
    let reminder: Bool
    
    init(
        uid: String = UUID().uuidString,
        position: Int,
        content: String,
        importance: Importance,
        expirationDate: Date,
        category: Category = .personal,
        reminder: Bool = false
    ) {
        self.uid = uid
        self.position = position
        self.content = content
        self.importance = importance
        self.expirationDate = expirationDate
        self.category = category
        self.reminder = reminder
    }
}

enum Importance : String, CaseIterable {
    case unimportant = "Unimportant"
    case regular = "Regular"
    case important = "Important"
}

enum Category : String, CaseIterable {
    case personal = "Personal"
    case work = "Work"
    case family = "Family"
}
