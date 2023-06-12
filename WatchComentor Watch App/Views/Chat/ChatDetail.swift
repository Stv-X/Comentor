//
//  ChatDetail.swift
//  Comentor Watch App
//
//  Created by 徐嗣苗 on 2023/6/12.
//

import SwiftUI
import SwiftData
import OpenAI

struct ChatDetail: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query
    private var chats: [ComentorChat]
    
    var chat: ComentorChat
    
    @State private var messageText = ""
    
    @State private var isRequestingAnswer = false
    
    @State private var deletingMessages = false
    
    @State private var didResend = false
    
    @AppStorage("APIKey") private var aiApiKey: String?
    @AppStorage("AIModel") private var aiModel: Model?
    @AppStorage("AITemperature") private var aiTemperature: Double = 0.5
    @AppStorage("ContextCount") private var aiContextCount: Int = 4
    
    var body: some View {
        ScrollView() {
            ForEach(chat.dialoguesArray) { dialogue in
                ChatDialogueCell(dialogue: dialogue,
                                 isRequestingAnswer: isRequestingAnswer)
                .scrollTransition(axis: .vertical) { content, phase in
                    content
                        .scaleEffect(phase.isIdentity ? 1.0 : 0.9)
                }
            }
            Spacer()
            textField
        }
        .scrollPosition(initialAnchor: .bottom)
        .contentMargins(.bottom, -20)
        .navigationTitle(chat.title)
        .task {
            if aiTemperature == 0.0 && aiContextCount == 0 {
                aiApiKey = ""
                aiModel = .gpt3_5Turbo
                aiTemperature = 0.5
                aiContextCount = 4
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .destructive) {
                    withAnimation {
                        deletingMessages = true
                    }
                } label: {
                    Label("Erase All Messages", systemImage: "trash")
                        .tint(.red)
                }
                .disabled(chat.dialogues.isEmpty || isRequestingAnswer)
            }
        }
        .alert("Erase All Messages?",
               isPresented: $deletingMessages) {
            Button(role: .destructive) {
                deleteAllDialogues()
                deletingMessages = false
            } label: {
                Text("Erase")
            }
            Button(role: .cancel) {
                deletingMessages = false
            } label: {
                Text("Cancel")
            }
        } message: {
            Text("You cannot undo this action.")
        }
    }
    
    var textField: some View {
        HStack {
            TextField("Ask anything", text: $messageText)
                .font(.footnote)
                .disabled(isRequestingAnswer)
            Button {
                if messageText == "" && !chat.dialogues.isEmpty {
                    withAnimation {
                        messageText = chat.latestDialogue?.ask ?? ""
                        didResend = true
                    }
                } else {
                    Task {
                        await sendMessage()
                    }
                }
            } label: {
                Image(systemName:
                        "arrow.up")
                .bold()
            }
            .frame(width: 42)
            .buttonStyle(.borderedProminent)
            .disabled(isRequestingAnswer || (messageText == "" && chat.dialogues.isEmpty))
            .alert("Resend?", isPresented: $didResend) {
                Button("Resend") {
                    didResend = false
                    Task {
                        await sendMessage()
                    }
                }
                
                Button("Cancel", role: .cancel) {
                    didResend = false
                }
            } message: {
                Text(chat.latestDialogue?.ask ?? "")
                    .font(.footnote)
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
}

