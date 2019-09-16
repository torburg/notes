import Foundation
import UIKit

struct Note {
    let uid: String
    let content: String
    let importance: Importance
    let expirationDate: Date
    let category: Category?
    let reminder: Bool
    
    init(
        uid: String = UUID().uuidString,
        content: String,
        importance: Importance,
        expirationDate: Date,
        category: Category? = nil,
        reminder: Bool = false
    ) {
        self.uid = uid
        self.content = content
        self.importance = importance
        self.expirationDate = expirationDate
        self.category = category
        self.reminder = reminder
    }
}

enum Importance : String, CaseIterable {
    case unimportant = "unimportant"
    case regular = "regular"
    case important = "important"
}

enum Category : String, CaseIterable {
    case personal = "Personal"
    case work = "Work"
    case family = "Family"
}
