//
//  SearchCategoryDetail.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/10.
//

import SwiftUI
import SwiftData

struct SearchCategoryDetail: View {
    var selection: SearchCategory
    
    @Query(sort: \.creationDate)
    var roadmaps: [Roadmap]
    
    var body: some View {
        ScrollView {
            if roadmaps.contains(where: { $0.category == selection.category.rawValue }) {
                ForEach(roadmaps.filter({ $0.category == selection.category.rawValue })) { roadmap in
                        RoadmapListItem(roadmap: roadmap)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                }
            } else {
                ContentUnavailableView {
                    Label("No Roadmaps", systemImage: "magnifyingglass")
                } description: {
                    Text("Chat with Comentor AI Robot to generate Study Road Map.")
                }
                .symbolEffect(.pulse, options: .speed(0.3))
            }
        }
        .navigationTitle(LocalizedStringKey(selection.category.rawValue.capitalized))
    }
}
