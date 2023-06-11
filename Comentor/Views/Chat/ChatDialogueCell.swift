//
//  ChatDialogueCell.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI
import MarkdownText

struct ChatDialogueCell: View {
    var dialogue: Dialogue
    
    @State var isRequestingAnswer: Bool
    
    @AppStorage("CurrentMessage") private var currentReceivedMessage = ""
    
    var body: some View {
        HStack {
            Spacer()
            Text(dialogue.ask)
                .padding(.horizontal, dialogue.ask.count <= 1 ? 3 : 0)
                .foregroundStyle(.white)
                .padding(12)
                .background(Color.accentColor)
                .clipShape(dialogue.ask.count > 3 ? AnyShape(ChatBubbleShape(direction: .right)) : AnyShape(Capsule()))
                .animation(.easeInOut(duration: 0.5), value: 0)
                .contextMenu {
                    Button {
                        dialogue.ask.copyToClipBoard()
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    ShareLink(items: [dialogue.ask]) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
        }
        HStack {
            if isRequestingAnswer && dialogue.answer == "" && currentReceivedMessage == "" {
                ProgressView()
#if os(macOS)
                    .scaleEffect(0.5)
#endif
            } else if isRequestingAnswer && dialogue.answer == "" && currentReceivedMessage != "" {
                MarkdownText(currentReceivedMessage)
                    .padding()
                    .background(.secondary.opacity(0.2))
                    .clipShape(currentReceivedMessage.count > 3 ? AnyShape(ChatBubbleShape(direction: .left)) : AnyShape(Capsule()))
                    .comentorAnswerMarkdownStyle()
                    .animation(.spring, value: currentReceivedMessage)
            } else {
                if dialogue.answer != "" {
                    MarkdownText(dialogue.answer)
                        .padding()
                        .background(.secondary.opacity(0.2))
                        .clipShape(dialogue.answer.count > 3 ? AnyShape(ChatBubbleShape(direction: .left)) : AnyShape(Capsule()))
                        .comentorAnswerMarkdownStyle()
                    
                        .contextMenu {
                            Button {
                                dialogue.answer.copyToClipBoard()
                            } label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                            ShareLink(items: [dialogue.answer]) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        }
                }
            }
            
            Spacer()
        }
    }
}

extension View {
    func comentorAnswerMarkdownStyle() -> some View {
        self.markdownHeadingStyle(.custom)
            .markdownQuoteStyle(.custom)
            .markdownCodeStyle(.custom)
            .markdownInlineCodeStyle(.custom)
            .markdownOrderedListBulletStyle(.custom)
            .markdownUnorderedListBulletStyle(.custom)
            .markdownImageStyle(.custom)
    }
}
