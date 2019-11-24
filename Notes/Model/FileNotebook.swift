import Foundation
import CocoaLumberjack

class FileNotebook {
    private(set) var notes: [Note] = []
    
    static var shared = FileNotebook()

    public func add(_ note: Note) {
        guard !containsNote(note) else { return }
        if notes.isEmpty {
            notes.append(note)
        } else {
            notes.insert(note, at: note.position)
        }
    }
    
    public func containsNote(_ note: Note) -> Bool {
        return notes.contains(where: {$0.uid == note.uid})
    }
    
    public func remove(with uid: String) {
        notes = notes.filter {$0.uid != uid}
    }
    
    public func save(to fileName: String) throws {
        if let fileUrlValue = getURL(of: fileName) {
            let arr: [[String: Any]] = notes.map{$0.json}
            let jsdata = try JSONSerialization.data(withJSONObject: arr, options: [])
            try jsdata.write(to: fileUrlValue)
        }
    }
    
    public func load(from fileName: String) {
        if let fileUrlValue = getURL(of: fileName) {
            guard let data = FileManager.default.contents(atPath: fileUrlValue.path) else { return }
            do {
                let array = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                guard let arr = array else { return }
                for json in arr {
                    if let note = Note.parse(json: json) {
                        notes.append(note)
                    }
                }
            } catch {
                print("Ошибка загрузки данных из файла: \(fileUrlValue)")
            }
        }
    }
    
    private func getURL(of fileName: String) -> URL? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        var isDir: ObjCBool = false
        
        let dirUrl = path.appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: dirUrl.path, isDirectory: &isDir), !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Ошибка создания директории \(fileName), \(error)")
                return nil
            }
        }
        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        // TODO: log dirUrl
//        DDLog.log(asynchronous: false, message: .init("\(dirUrl)"))
//
        let fileUrl = dirUrl.appendingPathComponent("Note")
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            if !FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil) {
                return nil
            }
        }
        return fileUrl
    }
    
    static func generateNotebook() {
        shared.add(Note(
            uid: UUID.init().uuidString,
            position: 0,
            content: "First expired",
            importance: Importance.allCases.randomElement()!,
            expirationDate: Date.expired,
            category: .personal)
        )
        shared.add(Note(
            uid: UUID.init().uuidString,
            position: 1,
            content: "Second expired",
            importance: Importance.allCases.randomElement()!,
            expirationDate: Date.expired,
            category: .work,
            reminder: true)
        )
        shared.add(Note(
            uid: UUID.init().uuidString,
            position: 2,
            content: "Short note",
            importance: .regular,
            expirationDate: Date.today,
            category: .personal)
        )
        shared.add(Note(
            uid: UUID.init().uuidString,
            position: 0,
            content: "Not so short note",
            importance: .regular,
            expirationDate: Date.tomorrow,
            category: .work,
            reminder: true)
        )
        shared.add(Note(
            uid: UUID.init().uuidString,
            position: 1,
            content: "This Romeo is bleeding but you can't see hi blood",
            importance: .regular,
            expirationDate: Date.tomorrow,
            category: .personal)
        )
        shared.add(Note(
            uid: UUID.init().uuidString,
            position: 0,
            content: "I, I can't get these memories out of my And some kind of madness has started to evolve I, I tried so hard to let you go        But some kind of madness is swallowing me whole, yeah I have finally seen the light And I have finally realized        What you mean Oh oh And now, I need to know is this real love Or is it just madness keeping us afloat? And when I look back at all the crazy fights we had Like some kind of madness Was taking control",
            importance: .regular,
            expirationDate: Date.future,
            category: .family)
        )
        for index in 1...2 {
            let uid = UUID.init().uuidString
            let position = index-1
            let content = "\(index)_Content"
            let importance = Importance.allCases.randomElement()!
            let expirationDate = Date.today
            let  note = Note(uid: uid, position: position, content: content, importance: importance, expirationDate: expirationDate)
            shared.add(note)
        }
    }
}

