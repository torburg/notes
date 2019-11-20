import Foundation

extension Note {
    
    var json: [String: Any] {
        var result = [String : Any]()
        result["uid"] = self.uid
        result["position"] = self.position
        result["content"] = self.content
        result["importance"] = self.importance.rawValue
        let date = self.expirationDate
        let dateStr = Date.formatter.string(from: date)
        result["expirationDate"] = dateStr
        result["category"] = self.category.rawValue
        result["reminder"] = self.reminder
        
        return result
    }
    
    static func parse(json: [String: Any]) -> Note? {
        
        let position = json["position"] as! Int
        guard let content = json["content"] as? String else {
            return nil
        }
        
        var importance = Importance.regular
        if let jsonImportance = json["importance"] as? String {
            importance = Importance(rawValue: jsonImportance)!
        }
        
        var expirationDate = Date()
        if let jsonDate = json["expirationDate"] as? String {
            expirationDate = Date.formatter.date(from: jsonDate)!
        }
        return Note(position: position, content: content, importance: importance, expirationDate: expirationDate)
    }
}

