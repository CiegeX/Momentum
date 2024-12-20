//
//  ContentView.swift
//  Momentum
//
//  Created by Auggie Dev on 12/17/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some View {
        VStack {
            Navbar()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
