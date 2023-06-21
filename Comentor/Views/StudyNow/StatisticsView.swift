//
//  StatisticsView.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/16.
//

import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    
    @State private var selectedCategory: StudyCategory?
    
    @Query
    private var roadmaps: [Roadmap]
    
    var body: some View {
        VStack {
            Text(selectedCategory?.localizedLabel ?? "Select a category to see statistics")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Chart(chartData) { element in
                SectorMark(
                    angle: .value("Count", element.count),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(element.category.getColor())
//                .opacity(element.category == selectedCategory ? 1.0 : 0.3)
            }
            .chartAngleSelection($selectedCategory)
            .frame(height: 300)
            .padding()
            
        }
    }
    
    private var chartData: [StatisticsData] {
        let categories = roadmaps.map { StudyCategory(rawValue: $0.category)! }
        
        var data: [StatisticsData] = []
        for category in categories {
            if let index = data.firstIndex(where: { $0.category == category }) {
                data[index].count += 1
            } else {
                data.append(StatisticsData(category, 1))
            }
        }
        return data
    }
}

struct StatisticsData: Identifiable, Hashable {
    var id = UUID()
    var category: StudyCategory
    var count: Int
    
    init(_ category: StudyCategory, _ count: Int) {
        self.category = category
        self.count = count
    }
}

