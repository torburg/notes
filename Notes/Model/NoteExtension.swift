import UIKit

extension Note {
    
    var json: [String: Any] {
        var result = [String : Any]()
        result["uid"] = self.uid
        result["title"] = self.title
        result["content"] = self.content
        if self.color != UIColor.white {
            result["color"] = self.color.toHexString()
        }
        if self.importance != Importance.regular {
            result["importance"] = self.importance.rawValue
        }
        if let date = self.selfDestructDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            let dateStr = formatter.string(from: date)
            result["selfDestructDate"] = dateStr
        }
        return result
    }
    
    static func parse(json: [String: Any]) -> Note? {
        
        guard let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String
            else {
                return nil
        }
        
        var color = UIColor.white
        if let jsonColor = json["color"] as? String {
            color = UIColor(hexString: jsonColor)
        }
        
        var importance = Importance.regular
        if let jsonImportance = json["importance"] as? String {
            importance = Importance(rawValue: jsonImportance)!
        }
        
        var selfDestructDate = Date()
        if let jsonDate = json["selfDestructDate"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            selfDestructDate = formatter.date(from: jsonDate)!
        }
        return Note(uid: uid, title: title, content: content, color: color, importance: importance, selfDestructDate: selfDestructDate)
    }
}

extension UIColor {
    convenience init(hexString:String) {
        let hexString:String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}

