//
//  ChatListItem.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI
import SwiftData

struct ChatListItem: View {
    @Environment(\.modelContext) private var modelContext
    
    var chat: ComentorChat
    
    var body: some View {
        NavigationLink {
            ChatDetail(chat: chat)
        } label: {
            cellLabel
        }
    }
    
    var cellLabel: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(chat.title)
                        .font(.headline)
                    
                    // Roadmap Preview
                    if let roadmap = chat.roadmap {
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(roadmap.color)
                            Text(roadmap.title)
                                .foregroundStyle(.secondary)
                                .font(.footnote)
                        }
                        .padding(4)
                        .background(.thinMaterial)
                        .cornerRadius(8)
                    }
                }
                Spacer()
                Text(chat.timestamp.formattedForLocalization())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            DialoguePreview(chat: chat)
        }
    }
}

struct DialoguePreview: View {
    var chat: ComentorChat
    
    var body: some View {
        if !chat.dialogues.isEmpty {
            if let latestDialogue = chat.latestDialogue {
                if !latestDialogue.answer.isEmpty {
                    Text(latestDialogue.answer)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                } else if !latestDialogue.ask.isEmpty {
                    Text(latestDialogue.ask)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            
        } else {
            Text("Empty Chat")
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }
}
