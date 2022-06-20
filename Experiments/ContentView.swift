//
//  ContentView.swift
//  Experiments
//
//  Created by Paul Zabelin on 4/14/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Button("Race DateFormatter",
                   action: DateFormatterRace.run)
            Button("Race Task Cancellation",
                   action: TaskCancellationRace.run)
            Button("Race AnyCancellable Set",
                   action: AnyCancellableSet.run)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
