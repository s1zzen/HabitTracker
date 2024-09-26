//
//  DateFormatter.swift
//  HabitTracker
//
//  Created by Сергей Баскаков on 28.07.2024.
//

import Foundation

var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .none
    dateFormatter.dateFormat = "MM/dd/YY"
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "E"
    return dateFormatter
}()

extension Date {
    var dateTimeString: String { dateFormatter.string(from: self) }

    func dayOfWeek() -> Int {
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: self)
        if weekDay == 1 {
            return 7
        } else {
            return weekDay - 1
        }
    }
}
