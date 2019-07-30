import Foundation
import UIKit

struct Note {
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    let selfDestructDate: Date?
    
    init(
        uid: String = UUID().uuidString,
        title: String,
        content: String,
        color: UIColor = UIColor.white,
        importance: Importance,
        selfDestructDate: Date? = nil
    ) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructDate = selfDestructDate
    }
}

enum Importance : String {
    case unimportant = "unimportant"
    case regular = "regular"
    case important = "important"
}
