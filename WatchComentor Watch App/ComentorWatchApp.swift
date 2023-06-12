//
//  ComentorWatchApp.swift
//  Comentor Watch App
//
//  Created by 徐嗣苗 on 2023/6/12.
//

import SwiftUI
import SwiftData

@main
struct Comentor_Watch_App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(
            for: ComentorChat.self,
            isUndoEnabled: true
        )
    }
}
