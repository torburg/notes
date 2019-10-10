//
//  LoadNotes.swift
//  Notes
//
//  Created by Maksim Torburg on 08/10/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import Foundation

class LoadNotes: BaseOperation {
    var result: [Note]?
    
    override func main() {
        result = notebook.notes
    }
}
