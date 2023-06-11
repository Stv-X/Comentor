//
//  SidebarNavigation.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import SwiftUI
import SwiftData


struct SidebarNavigation: View {
    
    @Query(sort: \.creationDate)
    private var tags: [Tag]
    
    @State private var selectedItem: NavigationItem?
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } content: {
            if let selection = selectedItem {
                selection.destination
                    .navigationTitle(LocalizedStringKey(selection.title))
            }
        } detail: {
            WelcomeView()
        }
        .task {
            selectedItem = navigationItems.first!
        }
    }
    
    private var sidebar: some View {
        List(selection: $selectedItem) {
            ForEach(navigationItems) { item in
                NavigationLink(value: item) {
                    Label(LocalizedStringKey(item.title), systemImage: item.image)
                }
            }
            
            if !tags.isEmpty {
                Section("Tags") {
                    ForEach(tags) { tag in
                        TagNavigationItem(tag: tag)
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Comentor")
        .background(.ultraThinMaterial)
    }
}

struct TagNavigationItem: View {
    var tag: Tag
    var body: some View {
        NavigationLink {
            TagDetail(tag: tag)
        } label: {
            Label(tag.title, systemImage: "number")
        }
    }
}
