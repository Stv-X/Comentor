//
//  StudyNowView.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI
import SwiftData

struct StudyNowView: View {
    
    @Query(sort: \.creationDate, order: .reverse)
    private var roadmaps: [Roadmap]
    @Query(sort: \.tagIdentifier, order: .forward)
    private var tags: [Tag]
    
    @State private var showStatistics = false
    
    var body: some View {
        if roadmaps.isEmpty {
            ContentUnavailableView {
                Label("No Roadmaps", systemImage: "fossil.shell.fill")
            } description: {
                Text("Chat with Comentor AI Robot to generate Study Roadmaps.")
            }
            .symbolEffect(.pulse, options: .speed(0.3))
        } else {
            ScrollView {
                if !tags.isEmpty {
                    TagList(tags: tags)
                    Divider()
                }
                RoadmapList(roadmaps: roadmaps)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        showStatistics = true
                    } label: {
                        Label("Statistics", systemImage: "chart.pie")
                    }
                }
            }
            .sheet(isPresented: $showStatistics) {
                StatisticsView()
            }
        }
    }
}

#Preview {
    StudyNowView()
}
