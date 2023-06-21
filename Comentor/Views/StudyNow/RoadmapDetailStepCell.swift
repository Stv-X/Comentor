//
//  RoadmapDetailStepCell.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/11.
//

import SwiftUI

struct RoadmapDetailStepCell: View {
    var step: Step
    
    @State private var isNotFinished = true
    
    var body: some View {
        DisclosureGroup(isExpanded: $isNotFinished) {
            VStack {
                Text(step.content)
                    .strikethrough(step.isFinished)
                
                if !step.isFinished {
                    if let chat = step.roadmap!.chat {
                        NavigationLink {
                            NavigationStack {
                                ChatDetail(chat: chat, messageText: step.content)
                            }
                        } label: {
                            Image(systemName: "quote.bubble")
                                .foregroundStyle(.accent)
                        }
                    }
                }
            }
        } label: {
            HStack {
                HStack(alignment: .top) {
                    Text(step.index.description)
                    Text(step.title)
                        .strikethrough(step.isFinished)
                }
                .frame(maxWidth: 300, alignment: .leading)
                
                Spacer()
                if step.isFinished {
                    Text(step.finishDate!.formattedForLocalization())
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(
                        step.isFinished ? step.roadmap!.color : .secondary.opacity(0.3))
                    .onTapGesture {
                        withAnimation {
                            step.toggleFinishState()
                        }
                    }
            }
            .font(.title3)
            .bold()
        }
        .task {
            withAnimation {
                isNotFinished = !step.isFinished
            }
        }
        .onChange(of: step.isFinished) {
            withAnimation {
                isNotFinished = !step.isFinished
            }
        }
    }
}
