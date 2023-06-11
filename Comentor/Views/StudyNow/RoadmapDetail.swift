//
//  RoadmapDetail.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/10.
//

import SwiftUI
import SwiftData

struct RoadmapDetail: View {
    
    @Query
    private var roadmaps: [Roadmap]
    
    var roadmap: Roadmap
    
    var body: some View {
        if roadmaps.contains(roadmap) {
            NavigationStack {
                List {
                    Section("Steps") {
                        ForEach(roadmap.stepsArray) { step in
                            RoadmapDetailStepCell(step: step)
                        }
                    }
                    
                    if let chat = roadmap.chat {
                        Section("Chat") {
                            NavigationLink {
                                NavigationStack {
                                    ChatDetail(chat: chat)
                                }
                            } label: {
                                ChatListItem(chat: chat)
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItemGroup {
                        Button {
                            withAnimation {
                                roadmap.isPinned.toggle()
                            }
                        } label: {
                            Label("Pin", systemImage: roadmap.isPinned ? "pin.fill" : "pin")
                        }
                        
                        Menu {
                            Button {
                                
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            Menu {
                                Button(role: .destructive) {
                                    
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Label("More", systemImage: "ellipsis.circle")
                        }
                        
                    }
                }
#if os(macOS)
                .frame(minWidth: 300)
#endif
            }
            .navigationTitle(roadmap.title)
        } else {
            ContentUnavailableView {
                Label("Select a roadmap", systemImage: "fossil.shell.fill")
            }
            .navigationTitle("")
        }
    }
}

