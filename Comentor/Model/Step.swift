//
//  Step.swift
//  Comentor
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
    
    var roadmap: Roadmap?
    
    init(index: Int, title: String, content: String) {
        self.index = index
        self.title = title
        self.content = content
    }
}

extension Step {
    @Transient
    var isFinished: Bool {
        return finishDate != nil
    }
    
    func toggleFinishState() {
        if self.isFinished {
            self.finishDate = nil
        } else {
            self.finishDate = Date()
        }
    }
}
