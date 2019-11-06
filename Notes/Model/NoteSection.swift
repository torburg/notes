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
    
    private var notes = [Note]()
    let title: String?
    let period: When
    
    init(notes: [Note], index: Int = 0) {
        self.notes = notes
        
        switch index {
        case 0:
            self.period = .today
            self.title = "Today \(When.today.rawValue)"
        case 1:
            self.period = .tomorrow
            self.title = "Tomorrow \(When.tomorrow.rawValue)"
        case 2:
            self.period = .future
            self.title = "Future \(When.future.rawValue)"
        default:
            self.period = .today
            self.title = "Today"
        }
    }
    
    
    
}
