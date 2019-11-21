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
        values = notes.sorted(by: { $0.position < $1.position })

        switch index {
        case 0:
            period = .today
            title = "\(When.today.rawValue)"
        case 1:
            period = .tomorrow
            title = "\(When.tomorrow.rawValue)"
        case 2:
            period = .future
            title = "\(When.future.rawValue)"
        default:
            period = .today
            title = "\(When.today.rawValue)"
        }
    }
}

extension NoteSection {
    
    func remove(_ note: Note) {
        values = values.filter( { $0.uid != note.uid } )
        values.filter({ $0.position > note.position}).forEach{ $0.position -= 1 }
    }
    
    func insert(note: Note, to index: Int) {
        values.insert(note, at: index)
        values.filter( { $0.position >= index} ).forEach{ $0.position += 1 }
        values.filter( { $0.uid == note.uid }).forEach{ $0.position = index }
    }
}
