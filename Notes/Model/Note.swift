import Foundation

struct Note {
    let uid: String
    let content: String
    let importance: Importance
    let expirationDate: Date
    let category: Category
    let reminder: Bool
    
    init(
        content: String,
        importance: Importance,
        expirationDate: Date,
        category: Category = .personal,
        reminder: Bool = false
    ) {
        self.uid = UUID().uuidString
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
