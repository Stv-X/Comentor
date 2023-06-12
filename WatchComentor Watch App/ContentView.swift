//
//  ContentView.swift
//  Comentor Watch App
//
//  Created by 徐嗣苗 on 2023/6/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                   ChatView()
                } label: {
                    Label("Chat", systemImage: "text.bubble.left.and.bubble.right")
                }
                NavigationLink {
                    SettingsView()
                } label: {
                    Label("Settings", systemImage: "gear")
                }
            }
            .navigationTitle("Comentor")
        }
    }
}

#Preview {
    ContentView()
}
