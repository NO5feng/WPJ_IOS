//
//  ContentView.swift
//  WPJ_IOS
//
//  Created by feng on 2026/3/4.
//

import SwiftUI

struct ContentView: View {
    @State private var showStartup = true
    private let startupDelay: TimeInterval = 1.2

    var body: some View {
        ZStack {
            if showStartup {
                StartupView()
                    .transition(.opacity)
            } else {
                HomeView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + startupDelay) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showStartup = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
