//
//  DateExtension.swift
//  Trickl
//
//  https://stackoverflow.com/questions/50950092/calculating-the-difference-between-two-dates-in-swift

import Foundation
import SwiftUI


extension Date {
    /**
     whether this date falls between the 2 provided dates (inclusive)
     */
    func between(_ start:Date,_ end:Date) -> Bool {
        start <= self && self <= end
    }
}

extension Date {
    /// find the most recent `Date` that shares a 24h time with provided `Date`
    func roundDown(to other: Date) -> Date {
        guard self != other else { return self }
        
        if other > self {
            let timeOffset = (other - self).truncatingRemainder(dividingBy: .day)
            return self - (.day - timeOffset)
        } else {
            let timeOffset = (self - other).truncatingRemainder(dividingBy: .day)
            return self - timeOffset
        }
    }
}

extension Date {
    /// get the short weekday name
    /// uses "Mon" to "Sun" in EN, hopefully translates well to other languages
    public func shortWeekday() -> String {
        DateFormatter()
            .shortWeekdaySymbols[Calendar.current.component(
                .weekday,
                from: self
            /// fix offset from 1 indexed components to zero indexed name array
            ) - 1]
    }
}
