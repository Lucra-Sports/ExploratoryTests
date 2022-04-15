//
//  DateFormatterRace.swift
//  Experiments
//
//  Created by Paul Zabelin on 4/14/22.
//

import Foundation

enum DateFormatterRace {
    static func run() {
        let dateFormatter = ISO8601DateFormatter()
        (1...1000).forEach { _ in
            Task {
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                let string = dateFormatter.string(from: Date())
                let date = dateFormatter.date(from: string)
                assert(dateFormatter.string(from: date!) == string)
            }
        }
    }
}
