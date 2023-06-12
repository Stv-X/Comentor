//
//  ChatListItem.swift
//  Comentor Watch App
//
//  Created by 徐嗣苗 on 2023/6/12.
//

import SwiftUI

struct ChatListItem: View {
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
                        .lineLimit(1)
                } else if !latestDialogue.ask.isEmpty {
                    Text(latestDialogue.ask)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
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
