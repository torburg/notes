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
        
        let dirUrl = path.appendingPathComponent("Notes")
        if !FileManager.default.fileExists(atPath: dirUrl.path, isDirectory: &isDir), !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Ошибка создания директории \"Notes\", \(error)")
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
}

