import Foundation

struct Note {
    let uid: String
    var position: Int
    let content: String
    let importance: Importance
    let expirationDate: Date
    let category: Category
    let reminder: Bool
    
    init(
        uid: String,
        position: Int,
        content: String,
        importance: Importance,
        expirationDate: Date,
        category: Category,
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

    static var allCases: [Importance] {
        return [.unimportant, .regular, .important]
    }
}

enum Category : String, CaseIterable {
    case personal = "Personal"
    case work = "Work"
    case family = "Family"

    static var allCases: [Category] {
        return [.personal, .work, .family]
    }
}
