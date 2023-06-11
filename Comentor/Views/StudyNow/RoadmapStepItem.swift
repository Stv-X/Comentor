//
//  RoadmapStepItem.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/10.
//

import SwiftUI
import SwiftData

struct RoadmapStepItem: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var step: Step
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Text(step.index.description)
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundStyle(colorScheme == .light ? Color.black.opacity(0.1) : Color.white.opacity(0.3))
            }
            .offset(y: 20)
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .top) {
                    Text(step.title)
                        .lineLimit(1)
                        .strikethrough(step.isFinished)
                    if step.isFinished {
                        Image(systemName: "checkmark.circle")
                    }
                }
                .bold()
                .foregroundColor(.white)
                Divider()
                Text(step.content)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.6))
                    .lineLimit(2)
                    .strikethrough(step.isFinished)
                Spacer()
            }
            .padding(.top, 8)
        }
        .frame(width: 180, height: 80)
        .padding(.horizontal, 8)
        .background(colorScheme == .light ? Color.black.opacity(0.2) : Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .onTapGesture {
            withAnimation {
                step.toggleFinishState()
            }
        }
    }
}
