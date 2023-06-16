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
    
    @Query
    private var roadmaps: [Roadmap]
    
    var body: some View {
        Chart(chartData, id: \.id) { element in
            BarMark(
                x: .value("Count", element.count),
                stacking: .normalized
            )
            .foregroundStyle(element.category.getColor())
        }
        .frame(height: 80)
        .chartXAxis(.hidden)
        .padding()
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

