import Foundation
import CocoaLumberjack

class FileNotebook {
    private(set) var notes: [Note] = []
    
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
    
    public func saveToFile() {
        if let fileUrlValue = getFileUrl() {
            let arr: [[String: Any]] = notes.map{$0.json}
            do {
                let jsdata = try JSONSerialization.data(withJSONObject: arr, options: [])
                try jsdata.write(to: fileUrlValue)
            } catch {
                print("Ошибка записи в файл, \(error)")
            }
        }
    }
    
    public func loadFromFile() {
        if let fileUrlValue = getFileUrl() {
            guard let data = FileManager.default.contents(atPath: fileUrlValue.path) else { return }
            do {
                let array = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                guard let arr = array else { return }
                notes.removeAll()
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
    
    private func getFileUrl() -> URL? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        var isDir: ObjCBool = false
        
        let dirUrl = path.appendingPathComponent("Deleted notes")
        if !FileManager.default.fileExists(atPath: dirUrl.path, isDirectory: &isDir), !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Ошибка создания директории \"Deleted notes\", \(error)")
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
    
    static func generateNotebook() -> [Note] {
        var fileNotebook: [Note] = []
        fileNotebook.append(Note(
            uid: UUID().uuidString,
            content: "Короткая такая заметочка",
            importance: .regular,
            expirationDate: Date(),
            category: .personal)
        )
        fileNotebook.append(Note(
            uid: UUID().uuidString,
            content: "Заметка уже слегка подлиннее, чем предыдущая",
            importance: .regular,
            expirationDate: Date.tomorrow,
            category: .work,
            reminder: true)
        )
        fileNotebook.append(Note(
            uid: UUID().uuidString,
            content: "Не то, что бы прям уж очень длинная заметка, но все-таки заметно длиннее, чем те две,          которые были до этого",
            importance: .regular,
            expirationDate: Date.tomorrow,
            category: .personal)
        )
        fileNotebook.append(Note(
            uid: UUID().uuidString,
            content: "А у этой заметки содержание по-настоящему длинное-предлинное, даже ни в какое сравнение с          треями предыдущими не идет. А все отчего? Да просто от того, что нужно затестировать как-то             поведение ячейки таблицы, когда у нее в содержании находиться очень длинные текст. Даже не знаю,            стоит ли еще добавить что-нибудь к вышесказанному. Пожалуй, что и нет. Поэтому на сем и закончу.",
            importance: .regular,
            expirationDate: Date.future,
            category: .family)
        )
        for index in 1...20 {
            let content = "\(index)_Content"
            let importance = Importance.allCases.randomElement()!
            //            let tomorrow = TimeInterval(60 * 60 * 24)
            let expirationDate = Date(timeInterval: 0, since: Date())
            let  note = Note(uid: UUID().uuidString, content: content, importance: importance, expirationDate: expirationDate)
            fileNotebook.append(note)
        }
        return fileNotebook
    }
    
    
    static var basicNotesList: [Note] = [
        Note(
            uid: "1",
            content: "contetetetete_afjna3kjfnkjwabfkjbwqkjfbawkjfbakjwbfkjabfkjwbfkjawbfkjbawkjfbkjawbfakwfbkwjbfkjawbfkjawbkjfbkjawbfkjawbkfjbawkjfbjkawbfjkwabfkjbwkjbfkjwabkjfbawkjbfkjawbfkjabwkjfbakwjfbkajwbfkjabfkbfkwabfkwabkfbwkfbakwjfbakwf",
            importance: Importance.important,
            expirationDate: Date()
        ),
        Note(
            uid: "2",
            content: "kmakfm",
            importance: Importance.important,
            expirationDate: Date.tomorrow
        ),
        Note(
            uid: "3",
            content: "123213313 afjna3kjfnkjwabfkjbwqkjfbawkjfbakjwbfkjabfkjwbfkjawbfkjbawkjfbkjawbfakwfbkwjbfkjawbfkjawbkjfbkjawbfkjawbkfjbawkjfbjkawbfjkwabfkjbwkjbfkjwabkjfbawkjbfkjawbfkjabwkjfbakwjfbkajwbfkjabfkbfkwabfkwabkfbwkfbakwjfbakwf",
            importance: Importance.important,
            expirationDate: Date()
        ),
        Note(
            uid: "4",
            content: "qkdpwd",
            importance: Importance.important,
            expirationDate: Date.future
        )
    ]
}

