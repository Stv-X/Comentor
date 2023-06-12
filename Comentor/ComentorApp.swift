//
//  ComentorApp.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI
import SwiftData

@main
struct ComentorApp: App {

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
