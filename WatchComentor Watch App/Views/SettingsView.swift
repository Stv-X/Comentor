//
//  SettingsView.swift
//  Comentor Watch App
//
//  Created by 徐嗣苗 on 2023/6/12.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("APIKey") private var aiApiKey: String = ""
    @AppStorage("APIHost") private var aiApiHost: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section("OpenAI API Key") {
                    SecureField("sk-...", text: $aiApiKey)
                }
                
                Section("Customized API Domain") {
                    TextField("example.com", text: $aiApiHost)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
