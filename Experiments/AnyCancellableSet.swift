//
//  TaskCancellationRace.swift
//  Experiments
//
//  Created by Derek Quinn on 6/20/22.
//

import Combine
import Foundation

enum AnyCancellableSet {
    static func run() {
        var cancellables = Set<AnyCancellable>()

        let queue = DispatchQueue(label: "race storing AnyCancellable in Set", attributes: .concurrent)
        while true {
            queue.async {
                    (1...10).publisher.sink {
                        print($0)
                    }.store(in: &cancellables)
            }
        }
    }
}
