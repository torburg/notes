//
//  SaveNotes.swift
//  Notes
//
//  Created by Maksim Torburg on 08/10/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import Foundation

class SaveNotes: BaseOperation {
    private let note: Note
    
    init(note: Note, to fileNotebook: FileNotebook) {
        self.note = note
        super.init(notebook: fileNotebook)
    }
    
    override func main() {
        notebook.add(note)
        do {
            try notebook.saveToFile(storeFileName)
        } catch {
            // TODO: - Log
            print("Ошибка записи в файл \(storeFileName), \(error)")
        }
    }
    func deleted() {
        do {
            try notebook.saveToFile(deletedFileName)
        } catch {
            // TODO: - Log
            print("Ошибка записи в файл \(deletedFileName), \(error)")
        }
    }
}
