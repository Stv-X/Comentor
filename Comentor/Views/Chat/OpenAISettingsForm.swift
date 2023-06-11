//
//  OpenAISettingsForm.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/11.
//

import SwiftUI
import OpenAI

struct OpenAISettings: Identifiable {
    let id = UUID()
    var key: String
    var host: String
    var model: Model
    var temperature: Double
    var contextCount: Int
    
    init() {
        self.key = ""
        self.host = "api.openai.com"
        self.model = .gpt3_5Turbo
        self.temperature = 0.5
        self.contextCount = 4
    }
}

struct OpenAISettingsForm: View {
    @AppStorage("APIKey") private var aiApiKey: String = ""
    @AppStorage("APIHost") private var aiApiHost: String = ""
    @AppStorage("AIModel") private var aiModel: Model = .gpt3_5Turbo
    @AppStorage("AITemperature") private var aiTemperature: Double = 0.5
    @AppStorage("ContextCount") private var aiContextCount: Int = 4
    
    @Binding var isPresented: Bool
    @State private var currentSettings = OpenAISettings()
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 8) {
                        
#if os(macOS)
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundColor(.accentColor)
                                .font(.title3)
                                .background(.clear)
                            Text("OpenAI Key")
                                .font(.title3)
                                .bold()
                            Spacer()
                        }
                        Divider()
                        
                        Text("Comentor's intelligence, as well as the globally popular AI ChatGPT, rely on the same technology and leverage the OpenAI API. The current version of Comentor requires you to provide an API Key in order to access all features.")
#else
                        Image(systemName: "key.fill")
                            .foregroundColor(.accentColor)
                            .font(.system(size: 50))
                            .background(.clear)
                        Text("OpenAI Key")
                            .font(.title3)
                            .bold()
                        
                        Text("Comentor's intelligence, as well as the globally popular AI ChatGPT, rely on the same technology and leverage the OpenAI API. The current version of Comentor requires you to provide an API Key in order to access all features.")
                            .multilineTextAlignment(.center)
#endif
                    }
                    .padding(.vertical)
                    Spacer()
                    
                }
                
                Section("OpenAI API Key") {
                    SecureField("sk-...", text: $aiApiKey)
                    Button {
                        
                    } label: {
                        Text("Validate")
                    }
                }
                
                Section("Customized API Domain") {
                    TextField("example.com", text: $aiApiHost)
                    Button {
                        
                    } label: {
                        Text("Validate")
                    }
                }
                
                Section("Advanced") {
                    HStack {
                        Picker("Model", selection: $aiModel) {
                            ForEach(Model.allCases) { model in
                                Text(model)
                                    .tag(model)
                            }
                        }
                    }
                    
                    HStack(spacing: 60) {
                        Text("Temperature")
                        VStack(spacing: -10) {
                            HStack {
                                Text("Precise")
                                Spacer()
                                Text("Creative")
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 3)
                            Slider(value: $aiTemperature, in: 0...0.9, step: 0.1)
                        }
                    }
                    
                    Stepper(value: $aiContextCount, in: 1...10, step: 1) {
                        HStack {
                            Text("Context Messages")
                            Spacer()
                            Text("\(aiContextCount)")
                        }
                    }
                }
                
            }
#if os(macOS)
            .textFieldStyle(.roundedBorder)
#endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        UserDefaults.standard.set(true, forKey: "isInitialLaunch")
                        aiApiKey = UserDefaults.standard.string(forKey: "APIKey") ?? ""
                        aiApiHost = UserDefaults.standard.string(forKey: "APIHost") ?? "api.openai.com"
                        isPresented = false
                    } label: {
                        Text("Confirm")
                    }
                    
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        UserDefaults.standard.set(true, forKey: "isInitialLaunch")
                        aiApiKey = currentSettings.key
                        aiModel = currentSettings.model
                        aiApiHost = currentSettings.host
                        aiTemperature = currentSettings.temperature
                        aiContextCount = currentSettings.contextCount
                        isPresented = false
                    } label: {
                        Text("Cancel")
                    }
                    
                }
            }
            .navigationTitle("AI Settings")
            
            .task {
                
                if aiTemperature == 0.0 && aiContextCount == 0 {
                    aiApiKey = ""
                    aiApiHost = "api.openai.com"
                    aiModel = .gpt3_5Turbo
                    aiTemperature = 0.5
                    aiContextCount = 4
                }
                
                currentSettings.key = aiApiKey
                currentSettings.host = aiApiHost
                currentSettings.model = aiModel
                currentSettings.temperature = aiTemperature
                currentSettings.contextCount = aiContextCount
            }
        }
#if os(macOS)
        .frame(minWidth: 300, maxWidth: 500, minHeight: 400, maxHeight: 600)
#endif
    }
}
