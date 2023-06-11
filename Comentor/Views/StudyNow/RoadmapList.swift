//
//  RoadmapList.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/10.
//

import SwiftUI
import SwiftData

struct RoadmapList: View {
    @Environment(\.modelContext) private var modelContext
    
    var roadmaps: [Roadmap]
    
    @State private var iconWidth: CGFloat = 200
    
    var body: some View {
        VStack {
            if roadmaps.contains(where: { $0.isPinned }) {
                Section {
                    ForEach(roadmaps.filter({ $0.isPinned })) { roadmap in
                        RoadmapListItem(roadmap: roadmap)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                    }
                } header: {
                    HStack {
                        Text("Pinned")
                            .bold()
                            .font(.title3)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                Divider()
            }
            ForEach(roadmaps.filter({ !$0.isPinned })) { roadmap in
                RoadmapListItem(roadmap: roadmap)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
            }
        }
    }
}
