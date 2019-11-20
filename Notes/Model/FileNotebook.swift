import Foundation
import CocoaLumberjack

class FileNotebook {
    private(set) var notes: [Note] = []
    
    static var shared = FileNotebook()

    public func add(_ note: Note) {
        guard !containsNote(note) else { return }
        notes.append(note)
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
        
        self.shared.add(Note(
            position: 2,
            content: "Короткая такая заметочка",
            importance: .regular,
            expirationDate: Date(),
            category: .personal)
        )
        self.shared.add(Note(
            position: 0,
            content: "Заметка уже слегка подлиннее, чем предыдущая",
            importance: .regular,
            expirationDate: Date.tomorrow,
            category: .work,
            reminder: true)
        )
        self.shared.add(Note(
            position: 1,
            content: "Не то, что бы прям уж очень длинная заметка, но все-таки заметно длиннее, чем те две,          которые были до этого",
            importance: .regular,
            expirationDate: Date.tomorrow,
            category: .personal)
        )
        self.shared.add(Note(
            position: 0,
            content: "А у этой заметки содержание по-настоящему длинное-предлинное, даже ни в какое сравнение с          треями предыдущими не идет. А все отчего? Да просто от того, что нужно затестировать как-то             поведение ячейки таблицы, когда у нее в содержании находиться очень длинные текст. Даже не знаю,            стоит ли еще добавить что-нибудь к вышесказанному. Пожалуй, что и нет. Поэтому на сем и закончу.",
            importance: .regular,
            expirationDate: Date.future,
            category: .family)
        )
        for index in 1...5 {
            let position = index-1
            let content = "\(index)_Content"
            let importance = Importance.allCases.randomElement()!
            let expirationDate = Date(timeInterval: 0, since: Date())
            let  note = Note(position: position, content: content, importance: importance, expirationDate: expirationDate)
            self.shared.add(note)
        }
    }
}

