//
//  TagListItem.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/10.
//

import SwiftUI

struct TagListItem: View {
    var tag: Tag
    
    var body: some View {
        NavigationLink {
            NavigationStack {
                TagDetail(tag: tag)
            }
        } label: {
            ZStack {
                HStack(spacing: 2) {
                    Image(systemName: "number")
                        .foregroundColor(.yellow)
                    
                    Text(tag.title)
                        .opacity(0.8)
                        .fontWidth(.condensed)
                    
                }
                .bold()
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(.yellow.opacity(0.3))
            }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding(.horizontal, 4)
        }
        .buttonStyle(.plain)
    }
}
