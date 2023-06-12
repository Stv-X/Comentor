//
//  TagDetail.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/10.
//

import SwiftUI
import SwiftData

struct TagDetail: View {
    
    @Query
    private var tags: [Tag]
    
    var tag: Tag
    
    var body: some View {
        if tags.contains(tag) {
            ScrollView {
                ForEach(tag.roadmaps) { roadmap in
                    RoadmapListItem(roadmap: roadmap, disableMenus: true)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
                
            }
            .navigationTitle("#\(tag.title)")
        } else {
            ContentUnavailableView {
                Label("Select a roadmap", systemImage: "fossil.shell.fill")
            }
            .symbolEffect(.pulse, options: .speed(0.3))
            .navigationTitle("")
        }
    }
}

