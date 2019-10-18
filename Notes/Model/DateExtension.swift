//
//  DateExtension.swift
//  Notes
//
//  Created by Maksim Torburg on 01/10/2019.
//  Copyright © 2019 Maksim Torburg. All rights reserved.
//

import Foundation


extension Date {
    static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }
    static var tomorrow:  Date { return Date().dayAfter }
    static var future: Date {
        return Date().dayAfter.dayAfter
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

