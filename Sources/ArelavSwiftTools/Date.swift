//
//  Date+String.swift
//  
//
//  Created by Juan Valera on 22/06/20.
//

import Foundation

public extension Date {
    static func date(year: Int, month: Int, day: Int, hour: Int, minute: Int, seconds: Int, timeZone: String) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.minute = seconds
        dateComponents.timeZone = TimeZone(abbreviation: timeZone)
        let userCalendar = Calendar.current
        return userCalendar.date(from: dateComponents)
    }
}

public extension Date {
    static var formatterRFC3339: DateFormatter {
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return RFC3339DateFormatter
    }
}

public extension String {
    var dateRFC3339 : Date? {
        Date.formatterRFC3339.date(from: self)
    }
}

public extension Date {
    var stringRFC3339 : String {
        Date.formatterRFC3339.string(from: self)
    }
    
    func format(_ fmt: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = fmt
        return formatter.string(from: self)
    }
    
}

public extension Date {
    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.formattingContext = .beginningOfSentence
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
