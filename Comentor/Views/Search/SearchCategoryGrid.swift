//
//  SearchCategoryGrid.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/10.
//

import SwiftUI

struct SearchCategoryGrid: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass
#endif
    
    var body: some View {
        VStack {
            HStack {
                Text("Browse Categories")
                    .font(.headline)
                    .bold()
                    .padding([.top, .leading])
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0),
                                     count: columnCount()),
                      spacing: 10) {
                ForEach(searchCategoryItems) { item in
                    SearchCategoryGridItem(selection: item)
                }
            }
                      .padding(.horizontal, 6)
            
        }
    }
    private func columnCount() -> Int {
#if os(iOS)
        return (hSizeClass == .compact) ? 2 : 3
#else
        return 3
#endif
    }
}

#Preview {
    SearchCategoryGrid()
}

struct SearchCategory: Identifiable {
    let id = UUID()
    let category: StudyCategory
    let image: String
    let color: Color
    
    init(_ category: StudyCategory) {
        self.category = category
        self.image = category.getImage()
        self.color = category.getColor()
    }
}

let searchCategoryItems = [
    SearchCategory(.coding),
    SearchCategory(.language),
    SearchCategory(.health),
    SearchCategory(.art),
    SearchCategory(.technology),
    SearchCategory(.math),
    SearchCategory(.biology),
    SearchCategory(.philosophy),
    SearchCategory(.business),
    SearchCategory(.sport)
]
