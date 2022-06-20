//
//  TaskCancellationRace.swift
//  Experiments
//
//  Created by Derek Quinn on 6/20/22.
//

import Combine
import Foundation

enum TaskCancellationRace {
    static func run() {
        var cancellables = Set<AnyCancellable>()

        let queue = DispatchQueue(label: "task race", attributes: .concurrent)
        while true {
            queue.async {
                
                for number in 1...10000000 {
                    let task = Task {
                        print("Sendable #\(number)")
                    }
                    
                    
                    task.store(in: &cancellables)
                    
                    task.cancel()
                }
                
            }
        }
    }
}
