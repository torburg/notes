//
//  NoteSection.swift
//  Notes
//
//  Created by Maksim Torburg on 03/11/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import Foundation

enum When: String, CaseIterable {
    case today = "Today"
    case tomorrow = "Tomorrow"
    case future = "Future"
    
    static var allValues: [When] {
        return [
            .today,
            .tomorrow,
            .future
        ]
    }
}

class NoteSection {
    
    var values = [Note]()
    var title: String?
    var period: When
    
    init(notes : [Note], index: Int = 0) {
        self.values = notes.sorted(by: { $0.position < $1.position })

        switch index {
        case 0:
            self.period = .today
            self.title = "\(When.today.rawValue)"
        case 1:
            self.period = .tomorrow
            self.title = "\(When.tomorrow.rawValue)"
        case 2:
            self.period = .future
            self.title = "\(When.future.rawValue)"
        default:
            self.period = .today
            self.title = "\(When.today.rawValue)"
        }
    }
}

extension NoteSection {
    
    func remove(_ note: Note) {
        self.values = self.values.filter( { $0.uid != note.uid } )
        self.values.filter({ $0.position > note.position}).forEach{ $0.position -= 1 }
    }
    
    func insert(note: Note, to index: Int) {
        self.values.insert(note, at: index)
        self.values.filter( { $0.position >= index} ).forEach{ $0.position += 1 }
        self.values.filter( { $0.uid == note.uid }).forEach{ $0.position = index }
    }
}
