//
//  Task+Utilities.swift
//  LucraSports
//
//  Created by Michael Schmidt on 4/29/22.
//

import Combine

public extension Task {
    /// Stores an AnyCancellable that will cancel the task when deallocated just like in Combine
    func store(in set: inout Set<AnyCancellable>) {
        set.insert(cancellable())
    }
    
    /// Returns an AnyCancellable that will cancel the task when deallocated just like in Combine
    func cancellable() -> AnyCancellable {
        AnyCancellable {
            self.cancel()
        }
    }
}
