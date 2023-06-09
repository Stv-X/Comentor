//
//  Comentor_NeueApp.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI
import SwiftData

@main
struct Comentor_NeueApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
