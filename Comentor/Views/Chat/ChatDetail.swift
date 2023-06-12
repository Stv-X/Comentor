//
//  ChatDetail.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI
import SwiftData
import OpenAI

struct ChatDetail: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query
    private var chats: [ComentorChat]
    
    var chat: ComentorChat
    
    @FocusState private var isTypingMessage: Bool
    
    @State private var messageText = ""
    
    @State private var isRequestingAnswer = false
    @State private var isGeneratingRoadmap = false
    
    @State private var isToastShowing = false
    @State private var toastTitle = ""
    @State private var toastSucceed = false

    
    @AppStorage("APIKey") private var aiApiKey: String?
    @AppStorage("AIModel") private var aiModel: Model?
    @AppStorage("AITemperature") private var aiTemperature: Double = 0.5
    @AppStorage("ContextCount") private var aiContextCount: Int = 4
    
    var body: some View {
        if chats.contains(chat) {
            VStack {
                ScrollView {
                    VStack {
                        ForEach(chat.dialoguesArray) { dialogue in
                            ChatDialogueCell(dialogue: dialogue,
                                             isRequestingAnswer: isRequestingAnswer)
                            .scrollTransition(axis: .vertical) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.20)
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.9)
                            }
                        }
                        .padding(.horizontal)
#if os(macOS)
                        .padding(.top, 4)
#endif
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    multiLineTextField
                        .padding()
                        .background(.ultraThinMaterial)
                        .frame(minWidth: 400)
                }
                .scrollPosition(initialAnchor: .bottom)
            }
            .overlay {
                if isToastShowing {
                    if isGeneratingRoadmap {
                        RoadmapGenerationStatusToast(status: .inProgress, title: toastTitle)
                    } else {
                        RoadmapGenerationStatusToast(status: toastSucceed ? .succeed : .failed, title: toastTitle)
                    }
                }
            }
            
            .onTapGesture {
                if !isToastShowing {
#if os(iOS)
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil, from: nil, for: nil
                    )
                    
#endif
                    isTypingMessage = false
                }
            }
            
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(chat.title)
#else
            .navigationSubtitle(chat.title)
#endif
            .task {
                if aiTemperature == 0.0 && aiContextCount == 0 {
                    aiApiKey = ""
                    aiModel = .gpt3_5Turbo
                    aiTemperature = 0.5
                    aiContextCount = 4
                }
            }
            
            //MARK: Toolbar
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        
                        Task {
                            await generateRoadmap()
                        }
                        
                    } label: {
                        Label("Generate Road Map", systemImage: "wand.and.stars")
                    }
                    .disabled(isRequestingAnswer || isGeneratingRoadmap || chat.roadmap != nil || chat.dialogues.isEmpty)
                }
                ToolbarItemGroup(placement: .primaryAction) {
                    Menu {
                        Button(role: .destructive, action: deleteAllDialogues) {
                            Label("Erase All Messages", systemImage: "trash")
                                .tint(.red)
                        }
                        .disabled(chat.dialogues.isEmpty)
                    } label: {
                        Label("Erase Messages", systemImage: "ellipsis.circle")
                    }
                    .disabled(isRequestingAnswer || isGeneratingRoadmap)
                }
            }
#if os(iOS)
            .toolbarRole(.browser)
#endif
            
        } else {
            ContentUnavailableView {
                Label("Select a chat", systemImage: "bubble.right.circle")
            }
            .navigationTitle("")
        }
    }
    
    var multiLineTextField: some View {
        HStack(alignment: .bottom) {
            TextField("Ask as your wish", text: $messageText, axis: .vertical)
                .focused($isTypingMessage)
                .lineLimit(8)
                .textFieldStyle(.roundedBorder)
            
            Button {
                Task {
                    await sendMessage()
                }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .bold()
                    .imageScale(.large)
                    .font(.title3)
                    .foregroundColor(.accentColor)
            }
            .keyboardShortcut(KeyboardShortcut(.return, modifiers: [.command]))
            .buttonStyle(.plain)
            .disabled(isRequestingAnswer || isGeneratingRoadmap || messageText.isEmpty)
        }
    }
    
    private func sendMessage() async {
        withAnimation(.smooth) {
            let newDialogue = Dialogue(messageText)
            newDialogue.chat = chat
            modelContext.insert(newDialogue)
            chat.dialogues.append(newDialogue)
            chat.timestamp = newDialogue.timestamp
            messageText = ""
            isRequestingAnswer = true
            
            let dialoguesToSend = chat.dialoguesArray
            
            Task {
                let (newAnswer, success) = await sendAndReceive(with: dialoguesToSend)
                if let latestDialogue = chat.latestDialogue {
                    latestDialogue.answer = newAnswer
                    latestDialogue.success = success
                    try! modelContext.save()
                }
                isRequestingAnswer = false

            }
        }
    }
    
    private func generateRoadmap() async {
        withAnimation {
            showToastInProgress()
            
            let dialoguesToSend = chat.dialoguesArray
            
            Task {
                let(yaml, success) = await roadmapYam(dialoguesToSend)
                hideToastInProgress()
                if success {
                    if let (newRoadmap, newSteps) = parsedRoadmap(from: yaml) {
                        modelContext.insert(newRoadmap)
                        for step in newSteps {
                            modelContext.insert(step)
                            step.roadmap = newRoadmap
                            newRoadmap.steps.append(step)
                        }
                        newRoadmap.chat = chat
                        chat.roadmap = newRoadmap
                        
                        showToast(newRoadmap.title, succeed: true)

                    } else {
                        showToast("Invalid YAML statement.", succeed: false)
                    }
                } else {
                    showToast("Failed to reach chatbot.", succeed: false)
                }
                isRequestingAnswer = false
            }
        }
    }
    
    private func deleteAllDialogues() {
        for dialogue in chat.dialoguesArray {
            modelContext.delete(dialogue)
        }
        chat.dialogues = []
        try! modelContext.save()
    }
    
    //MARK: Toast
    private func showToast(_ title: String, succeed: Bool) {
        toastTitle = title
        toastSucceed = succeed
        
        isToastShowing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.linear) {
                self.isToastShowing = false
            }
        }
    }
    
    private func showToastInProgress() {
        toastTitle = ""
        toastSucceed = false
        isGeneratingRoadmap = true
        isToastShowing = true
    }
    
    private func hideToastInProgress() {
        isGeneratingRoadmap = false
        isToastShowing = false
    }
}
