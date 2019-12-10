//
//  NoteSection.swift
//  Notes
//
//  Created by Maksim Torburg on 03/11/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import Foundation

enum When: String, CaseIterable {
    case expired = "Expired"
    case today = "Today"
    case tomorrow = "Tomorrow"
    case future = "Future"
    
    static var allValues: [When] {
        return [
            .expired,
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
            period = .expired
            title = "\(When.expired.rawValue)"
        case 1:
            period = .today
            title = "\(When.today.rawValue)"
        case 2:
            period = .tomorrow
            title = "\(When.tomorrow.rawValue)"
        case 3:
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
        if !values.isEmpty {
            values = values.filter{ $0.uid != note.uid }
        }
    }
    
    func insert(note: Note, to index: Int) {
        if !values.isEmpty {
            values.insert(note, at: index)
        } else {
            values.append(note)
        }
    }
}
