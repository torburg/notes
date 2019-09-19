import UIKit

extension Note {
    
    var json: [String: Any] {
        var result = [String : Any]()
        result["uid"] = self.uid
        result["content"] = self.content
        if self.importance != Importance.regular {
            result["importance"] = self.importance.rawValue
        }
        let date = self.expirationDate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let dateStr = formatter.string(from: date)
        result["expirationDate"] = dateStr
        
        return result
    }
    
    static func parse(json: [String: Any]) -> Note? {
        
        guard let uid = json["uid"] as? String,
            let content = json["content"] as? String
            else {
                return nil
        }
        
        var importance = Importance.regular
        if let jsonImportance = json["importance"] as? String {
            importance = Importance(rawValue: jsonImportance)!
        }
        
        var expirationDate = Date()
        if let jsonDate = json["expirationDate"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            expirationDate = formatter.date(from: jsonDate)!
        }
        return Note(uid: uid, content: content, importance: importance, expirationDate: expirationDate)
    }
}

