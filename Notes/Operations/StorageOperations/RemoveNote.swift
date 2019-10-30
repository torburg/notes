//
//  RemoveNote.swift
//  Notes
//
//  Created by Maksim Torburg on 30/10/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import UIKit

class RemoveNote: BaseOperation {
    let note: Note
    
    init(note: Note, from fileNotebook: FileNotebook) {
        self.note = note
        super.init(notebook: fileNotebook)
    }
    
    override func main() {
        notebook.remove(with: note.uid)
        do {
            try notebook.saveToFile()
        } catch {
            //ToDo Log
            print("Error to remove note")
        }
    }
}
