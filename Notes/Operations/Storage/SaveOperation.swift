//
//  SaveNotes.swift
//  Notes
//
//  Created by Maksim Torburg on 08/10/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import Foundation

class SaveOperation: BaseOperation {
    private let note: Note
    
    init(_ note: Note, to fileNotebook: FileNotebook) {
        self.note = note
        super.init(notebook: fileNotebook)
        
    }
    
    func main() {
        notebook.add(note)
        do {
            try notebook.save(to: storeFileName)
        } catch {
            // TODO: - Log
            print("Ошибка записи в файл \(storeFileName), \(error)")
        }
    }

    func deletedSave() {
        do {
            try notebook.save(to: deletedFileName)
        } catch {
            // TODO: - Log
            print("Ошибка записи в файл \(deletedFileName), \(error)")
        }
    }
}
