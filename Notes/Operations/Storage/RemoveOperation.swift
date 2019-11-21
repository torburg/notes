//
//  RemoveNote.swift
//  Notes
//
//  Created by Maksim Torburg on 30/10/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class RemoveOperation: BaseOperation {
    let note: Note

    init(_ note: Note, from fileNotebook: FileNotebook) {
        self.note = note
        super.init(notebook: fileNotebook)
    }

    func main() {
        notebook.remove(with: note.uid)
        do {
            try notebook.save(to: storeFileName)
        } catch {
            // TODO: - Log
            print("Error to remove note")
        }
    }

    func removeFromDeleted() {
        notebook.remove(with: note.uid)
        do {
            try notebook.save(to: deletedFileName)
        } catch {
            // TODO: - Log
            print("Error to remove note")
        }
    }
}
