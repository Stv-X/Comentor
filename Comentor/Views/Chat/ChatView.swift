//
//  ChatView.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI
import SwiftData

struct ChatView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \.timestamp, order: .reverse)
    private var chats: [ComentorChat]
    
    @State private var selection: ComentorChat?
    
    @State private var newChatTitle = ""
    @State private var showAddChat = false
    @State private var invalidTitle = false
    
    @State private var showOpenAISettings = false
    
    var body: some View {
        List(selection: $selection) {
            ForEach(chats) { chat in
                ChatListItem(chat: chat)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteChat(chat)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
        
        // No Chats
        .overlay {
            if chats.isEmpty {
                ContentUnavailableView {
                    Label("No Chats", systemImage: "bubble.right.circle")
                } description: {
                    Text("New chats you create will appear here.")
                }
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddChat = true
                } label: {
                    Label("New Chat", systemImage: "plus")
                }
            }
            ToolbarItem {
                Button {
                    showOpenAISettings = true
                } label: {
                    Label("AI Settings", systemImage: "gear")
                }
            }
        }
        .sheet(isPresented: $showOpenAISettings) {
            OpenAISettingsForm(isPresented: $showOpenAISettings)
        }
        // New Chat Toast
        .alert("New Chat",
               isPresented: $showAddChat,
               actions: {
            TextField("Enter title here…", text: $newChatTitle)
            Button("Add") {
                if !newChatTitle.isEmpty {
                    withAnimation {
                        if chats.contains(where: { $0.title == newChatTitle}) {
                            invalidTitle = true
                        } else {
                            let newChat = ComentorChat(newChatTitle)
                            modelContext.insert(newChat)
                            newChatTitle = ""
                            selection = chats.first(where: {$0.title == newChat.title})
                        }
                    }
                }
            }
            
            Button("Cancel", role: .cancel) {
                newChatTitle = ""
            }
        })
        
        // Invalid Chat Title
        .alert("Invalid Chat Title",
               isPresented: $invalidTitle,
               actions: {
            Button("OK") {
                newChatTitle = ""
            }
        },
               message: {
            Text("Chat title should be unique.")
        })
        
        
        
    }
    private func deleteChat(_ chat: ComentorChat) {
        if chat.objectID == selection?.objectID {
            selection = nil
        }
        modelContext.delete(chat)
        try! modelContext.save()
    }
    
}

#Preview {
    NavigationStack {
        ChatView()
    }
    .modelContainer(for: ComentorChat.self, inMemory: true)
}
