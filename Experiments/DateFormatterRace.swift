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
        let queue = DispatchQueue(label: "date formatter", attributes: .concurrent)
        while true {
            queue.async {
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                let string = dateFormatter.string(from: Date())
                _ = dateFormatter.date(from: string)
            }
        }
    }
}
