//
//  DateExtensions.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/11.
//

import Foundation

extension Date {
    var isToday: Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        
        return (selfCmps.year == nowComps.year) &&
        (selfCmps.month == nowComps.month) &&
        (selfCmps.day == nowComps.day)
    }
    
    func formattedForLocalization() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale.current)
            return dateFormatter.string(from: self)
        } else if calendar.isDateInYesterday(self) {
            
            return NSLocalizedString("Yesterday", comment: "Used to indicate that a message was sent yesterday.")
        } else {
            let components = calendar.dateComponents([.day], from: self, to: now)
            if let day = components.day, day < 7 {
                dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE", options: 0, locale: Locale.current)
                return dateFormatter.string(from: self)
            } else {
                dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d MMMM", options: 0, locale: Locale.current)
                return dateFormatter.string(from: self)
            }
        }
    }
}
