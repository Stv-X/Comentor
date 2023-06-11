//
//  ContentView.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isInitialLaunch = !UserDefaults.standard.bool(forKey: "isInitialLaunch")
    
    var body: some View {
#if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            TabNavigation()
                .sheet(isPresented: $isInitialLaunch) {
                    OpenAISettingsForm(isPresented: $isInitialLaunch)
                }
            
        } else {
            SidebarNavigation()
                .sheet(isPresented: $isInitialLaunch) {
                    OpenAISettingsForm(isPresented: $isInitialLaunch)
                }
        }
#else
        SidebarNavigation()
            .sheet(isPresented: $isInitialLaunch) {
                OpenAISettingsForm(isPresented: $isInitialLaunch)
            }
#endif
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .navigationTitle("Comentor")
    }
}
