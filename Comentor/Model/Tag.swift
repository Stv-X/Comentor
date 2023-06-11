//
//  Tag.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//
//

import Foundation
import SwiftData


@Model
final class Tag {
    var tagIdentifier: UUID
    var title: String
    var creationDate: Date
    
    @Relationship(.nullify, inverse: \Roadmap.tag) var roadmaps: [Roadmap]
    
    init(_ title: String, with roadmap: Roadmap) {
        self.title = title
        self.tagIdentifier = UUID()
        self.roadmaps = [roadmap]
        self.creationDate = Date()
    }
}
