//
//  Step.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//
//

import Foundation
import SwiftData


@Model
final class Step {
    var index: Int
    var title: String
    var content: String
    var finishDate: Date?
    
    @Transient
    var isFinished: Bool { self.finishDate != nil }
    
    var roadmap: Roadmap?
    
    init(index: Int, title: String, content: String) {
        self.index = index
        self.title = title
        self.content = content
    }
}

extension Step {
    func toggleFinishState() {
        if self.isFinished {
            self.finishDate = nil
        } else {
            self.finishDate = Date()
        }
    }
}
