//
//  SearchView.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    
    @Query(sort: \.creationDate)
    private var roadmaps: [Roadmap]
    
    @State private var searchText = ""
    
    var searchResults: [Roadmap] {
        if searchText.isEmpty {
            return roadmaps.map { $0 }
        } else {
            return roadmaps.map { $0 }.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText) ||
                $0.steps.contains(where: { $0.title.localizedCaseInsensitiveContains(searchText) || $0.content.localizedCaseInsensitiveContains(searchText)})
            }
        }
    }
    
    var body: some View {
        ScrollView {
            if searchText.isEmpty {
                SearchCategoryGrid()
#if os(macOS)
                    .frame(minWidth: 600)
#endif
            } else {
                ForEach(searchResults) { roadmap in
                    RoadmapListItem(roadmap: roadmap)
                        .padding(.horizontal)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Titles, Categories, and More")

    }
}

#Preview {
    SearchView()
}
