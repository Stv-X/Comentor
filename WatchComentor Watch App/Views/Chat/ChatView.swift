//
//  ChatView.swift
//  Comentor Watch App
//
//  Created by 徐嗣苗 on 2023/6/12.
//

import SwiftUI
import SwiftData

struct ChatView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \.timestamp, order: .reverse)
    private var chats: [ComentorChat]
    
    @State private var showAddChat = false
    @State private var newChatTitle = ""
    @State private var invalidTitle = false
    
    var body: some View {
        List {
            if chats.contains(where: { $0.isPinned }) {
                Section("Pinned") {
                    ForEach(chats.filter({ $0.isPinned })) { chat in
                        ChatListItem(chat: chat)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteChat(chat)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    withAnimation {
                                        chat.isPinned.toggle()
                                    }
                                } label: {
                                    Label("Pin", systemImage: chat.isPinned ? "pin.slash.fill" : "pin.fill")
                                        .tint(.yellow)
                                }
                            }
                    }
                }
            }
            ForEach(chats.filter({ !$0.isPinned })) { chat in
                ChatListItem(chat: chat)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteChat(chat)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            withAnimation {
                                chat.isPinned.toggle()
                            }
                        } label: {
                            Label("Pin", systemImage: chat.isPinned ? "pin.slash.fill" : "pin.fill")
                            .tint(.yellow)
                        }
                    }
            }
        }
        .navigationTitle("Chat")
        
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
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    showAddChat = true
                } label: {
                    Label("New Chat", systemImage: "plus")
                }
            }
        }
        
        .sheet(isPresented: $showAddChat){
            VStack {
                Text("New Chat")
                TextField("Enter title here…", text: $newChatTitle)
                Button("Add") {
                    withAnimation {
                        if chats.contains(where: { $0.title == newChatTitle}) {
                            invalidTitle = true
                        } else {
                            let newChat = ComentorChat(newChatTitle)
                            modelContext.insert(newChat)
                            newChatTitle = ""
                        }
                    }
                    showAddChat = false
                }
                .tint(.accentColor)
                .disabled(newChatTitle.isEmpty)
            }
            .onDisappear {
                showAddChat = false
                newChatTitle = ""
            }
        }
        
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
        modelContext.delete(chat)
        try! modelContext.save()
    }
}

#Preview {
    ChatView()
}
