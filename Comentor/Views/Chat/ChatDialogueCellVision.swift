//
//  ChatDialogueCellVision.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/22.
//


import SwiftUI

struct ChatDialogueCellVision: View {
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
                Text(currentReceivedMessage)
                    .padding()
                    .background(.secondary.opacity(0.2))
                    .clipShape(currentReceivedMessage.count > 3 ? AnyShape(ChatBubbleShape(direction: .left)) : AnyShape(Capsule()))
                    .animation(.spring, value: currentReceivedMessage)
            } else {
                if dialogue.answer != "" && dialogue.success {
                    Text(dialogue.answer)
                        .padding()
                        .background(.secondary.opacity(0.2))
                        .clipShape(dialogue.answer.count > 3 ? AnyShape(ChatBubbleShape(direction: .left)) : AnyShape(Capsule()))
                    
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
