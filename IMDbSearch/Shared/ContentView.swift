//
//  ContentView.swift
//  Shared
//
//  Created by Anderson, Marshall on 11/18/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button(
            action: {
                fetchJson(search: "guardians") { results in
                    results.forEach { print($0.description) }
                }
            },
            label: {
                Text("Search!")
            })
        .padding()


        // Button("Hello, world!")
            // .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
