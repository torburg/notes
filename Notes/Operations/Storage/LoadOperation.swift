//
//  LoadNotes.swift
//  Notes
//
//  Created by Maksim Torburg on 08/10/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import Foundation

class LoadOperation: BaseOperation {
    var result: [Note]?
    
    func main() {
        notebook.load(from: storeFileName)
        result = notebook.notes
    }
    
    func deletedLoad() {
        notebook.load(from: deletedFileName)
        result = notebook.notes
    }
}
