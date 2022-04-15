//
//  ContentView.swift
//  Experiments
//
//  Created by Paul Zabelin on 4/14/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Race DateFormatter",
               action: DateFormatterRace.run)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
