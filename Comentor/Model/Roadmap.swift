//
//  Roadmap.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/9.
//
//

import Foundation
import SwiftData
import SwiftUI


@Model
final class Roadmap {
    var title: String
    var category: String
    var creationDate: Date
    
    var isFolded: Bool = false
    var isPinned: Bool = false
    
    var chat: ComentorChat?
    var tag: Tag?
    
    @Relationship(.cascade, inverse: \Step.roadmap)
    var steps: [Step] = []
    
    init(_ title: String, category: StudyCategory) {
        self.title = title
        self.category = category.rawValue
        self.creationDate = Date()
    }
    
    init(_ title: String, category: String) {
        self.title = title
        self.category = category
        self.creationDate = Date()
    }
}

extension Roadmap {
    @Transient
    var color: Color {
        return StudyCategory(rawValue: category)?.getColor() ?? .accentColor
    }
    
    @Transient
    var complementaryColor: Color {
        return color.complementaryColor
    }
    
    @Transient
    var image: String {
        return StudyCategory(rawValue: category)?.getImage() ?? ""
    }
    
    @Transient
    var stepsArray: [Step] {
        let set = steps
        return set.sorted { $0.index < $1.index }
    }
    
}

enum StudyCategory: String, Codable {
    case coding = "coding"
    case language = "language"
    case health = "health"
    case art = "art"
    case technology = "technology"
    case math = "math"
    case biology = "biology"
    case philosophy = "philosophy"
    case business = "business"
    case sport = "sport"
}

extension StudyCategory {
    func getImage() -> String {
        switch self {
        case .coding:
            return "curlybraces"
        case .language:
            return "mouth"
        case .health:
            return "heart"
        case .art:
            return "paintpalette"
        case .technology:
            return "gear"
        case.math:
            return "function"
        case .biology:
            return "leaf"
        case .philosophy:
            return "brain.head.profile"
        case .business:
            return "briefcase"
        case .sport:
            return "figure.run"
        }
    }
    
    func getColor() -> Color {
        switch self {
        case .coding:
            return .blue
        case .language:
            return .red
        case .health:
            return .pink
        case .art:
            return .purple
        case .technology:
            return .gray
        case .math:
            return .teal
        case .biology:
            return .green
        case .philosophy:
            return .indigo
        case .business:
            return .orange
        case .sport:
            return .mint
        }
    }
    
    var localizedLabel: LocalizedStringKey {
        return LocalizedStringKey(stringLiteral: self.rawValue)
    }
    
    static func random() -> StudyCategory {
        let allValues: [StudyCategory] = [.coding, .language, .health, .art, .technology, .math, .biology, .philosophy, .business, .sport]
        let randomIndex = Int(arc4random_uniform(UInt32(allValues.count)))
        return allValues[randomIndex]
    }
}
