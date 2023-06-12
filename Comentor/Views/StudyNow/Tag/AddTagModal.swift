//
//  AddTagModal.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/10.
//

import SwiftUI
import SwiftData

struct AddTagModal: View {
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.colorScheme) private var colorScheme

    @Query(sort: \.tagIdentifier, order: .forward)
    private var tags: [Tag]
    
    var roadmap: Roadmap
    
    @Binding var isPresented: Bool
    @State private var title = ""
    
    var body: some View {
        
        HStack {
            Button {
                isPresented = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
            
            TextField("Add tag", text: $title)
                .textFieldStyle(.roundedBorder)
            #if os(iOS)
                .foregroundStyle(colorScheme == .light ? Color(uiColor: .darkText) : Color(uiColor: .lightText))
            #endif
            
            Button {
                addTag(title)
                isPresented = false
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.accentColor)
            }
            .disabled(title.isEmpty)
        }
        .padding(.horizontal, 8)
        .buttonStyle(.plain)
    }
    private func addTag(_ title: String) {
        withAnimation {
            if let tag = tags.first(where: {$0.title == title}) {
                tag.roadmaps.append(roadmap)
                roadmap.tag = tag
            } else {
                let newTag = Tag(title, with: roadmap)
                modelContext.insert(newTag)
                roadmap.tag = newTag
            }
        }
    }
}
