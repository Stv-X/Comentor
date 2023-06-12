//
//  TagList.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/10.
//

import SwiftUI
import SwiftData

struct TagList: View {
    var tags: [Tag]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(tags) { tag in
                    TagListItem(tag: tag)
                }
            }
        }
        .padding(.top)
    }
}
