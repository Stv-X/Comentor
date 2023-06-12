//
//  RoadmapListItem.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/10.
//

import SwiftUI
import SwiftData

struct RoadmapListItem: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    var roadmap: Roadmap
    var disableMenus: Bool
    
    @State private var isAddingTag = false
    
    init(roadmap: Roadmap, disableMenus: Bool) {
        self.roadmap = roadmap
        self.disableMenus = disableMenus
    }
    
    init(roadmap: Roadmap) {
        self.roadmap = roadmap
        self.disableMenus = false
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                NavigationLink {
                    NavigationStack {
                        RoadmapDetail(roadmap: roadmap)
                    }
                } label: {
                    HStack(alignment: .top) {
                        Image(systemName: roadmap.image)
#if os(iOS)
                            .font(.system(size: 40))
#else
                            .font(.system(size: 30))
                            .shadow(radius: 13)
#endif
                            .imageScale(.large)
                            .bold()
                        VStack(alignment: .leading) {
                            if let tag = roadmap.tag {
                                HStack(spacing: 0) {
                                    Image(systemName: "number")
                                        .imageScale(.small)
                                    Text(tag.title)
                                        .fontWidth(.condensed)
                                }
                                .bold()
                                .foregroundColor(.black)
                                .opacity(0.4)
                            }
                            
                            Text(roadmap.title)
                                .multilineTextAlignment(.leading)
                                .font(.title2)
                                .bold()
#if os(macOS)
                                .shadow(radius: 13)
#endif
                            
                            HStack {
                                Text("Creation Date")
                                Text(roadmap.creationDate.formattedForLocalization())
                            }
                            .font(.caption)
                            .bold()
                        }
                        Spacer()
                    }
                    .background(Color.white.opacity(0.001).cornerRadius(10))
                }
                .buttonStyle(.plain)
                
                Spacer()
                if !disableMenus {
                    Menu {
                        Button {
                            withAnimation {
                                roadmap.isPinned.toggle()
                            }
                        } label: {
                            Label(roadmap.isPinned ? "Unpin" : "Pin",
                                  systemImage: roadmap.isPinned ? "pin.slash" : "pin")
                        }
                        
                        if roadmap.tag == nil {
                            Button {
                                isAddingTag = true
                            } label: {
                                Label("Add tag", systemImage: "number")
                            }
                        } else {
                            Button {
                                removeTag()
                            } label: {
                                Label("Remove tag", systemImage: "number")
                            }
                        }
                        
                        Menu {
                            Button(role: .destructive) {
                                deleteRoadmap()
                            } label: {
                                Label("Delete this Roadmap", systemImage: "trash")
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .imageScale(.large)
                    }
                    .menuStyle(.button)
                    .buttonStyle(.plain)
                    .popover(isPresented: $isAddingTag) {
                        AddTagModal(roadmap: roadmap,
                                    isPresented: $isAddingTag)
                        .frame(width: 240)
                        .presentationCompactAdaptation(.none)
                    }
                }
            }
#if os(macOS)
            .foregroundStyle(.thickMaterial)
#else
            .foregroundStyle(.thinMaterial)
#endif
            Divider()
            HStack {
                if roadmap.isFolded {
                    HStack(spacing: 3) {
                        Text("\(roadmap.steps.count)")
                        Text("steps")
                    }
                    .opacity(0.4)
                    .font(.footnote)
                    .bold()
                }
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5)) {
                        roadmap.isFolded.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .rotation3DEffect(.degrees(roadmap.isFolded ? 0 : 180), axis: (x: 1, y: 0, z: 0))
                        .imageScale(.small)
                        .foregroundStyle(.thinMaterial)
                    
                }
                .buttonStyle(.plain)
            }
            
            if !roadmap.isFolded {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(roadmap.stepsArray) { step in
                            RoadmapStepItem(step: step)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .frame(height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
#if os(macOS)
                .shadow(radius: 13)
#endif
            }
        }
#if os(macOS)
        .frame(minWidth: 300)
#endif
        .padding(8)
        .background(
            LinearGradient(colors: [roadmap.color.complementaryColor, roadmap.color],
                           startPoint: colorScheme == .light ? .top : .bottom,
                           endPoint: colorScheme == .light ? .bottom : .top)
        )
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
    
    private func deleteRoadmap() {
        withAnimation {
            if let tag = roadmap.tag {
                if tag.roadmaps.count == 1 {
                    modelContext.delete(tag)
                }
            }
            
            modelContext.delete(roadmap)
            
            try! modelContext.save()
        }
    }
    
    private func removeTag() {
        withAnimation {
            if let tagToRemove = roadmap.tag {
                if tagToRemove.roadmaps.count == 1 {
                    modelContext.delete(tagToRemove)
                    roadmap.tag = nil
                    try! modelContext.save()
                }
            } else {
                roadmap.tag = nil
            }
        }
    }
}

