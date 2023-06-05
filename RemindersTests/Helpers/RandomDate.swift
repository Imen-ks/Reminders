//
//  RandomDate.swift
//  RemindersTests
//
//  Created by Imen Ksouri on 02/06/2023.
//

import Foundation

extension Date {
    static func random(in range: Range<Date>) -> Date {
        Date(
            timeIntervalSinceNow: .random(
                in: range.lowerBound.timeIntervalSinceNow...range.upperBound.timeIntervalSinceNow
            )
        )
    }
}
