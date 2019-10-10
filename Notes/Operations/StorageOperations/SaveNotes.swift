//
//  SaveNotes.swift
//  Notes
//
//  Created by Maksim Torburg on 08/10/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import Foundation

class SaveNotes: BaseOperation {
    private let note: Note?
    
    init(note: Note, fileNotebook: FileNotebook) {
        self.note = note
        super.init(notebook: fileNotebook)
    }
}
