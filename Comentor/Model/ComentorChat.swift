//
//  ComentorChat.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//
//

import Foundation
import SwiftData


@Model
final class ComentorChat {
    var title: String
    var timestamp: Date
    
    @Relationship(.cascade, inverse: \Dialogue.chat)
    var dialogues: [Dialogue] = []
    
    @Relationship(inverse: \Roadmap.chat)
    var roadmap: Roadmap?
    
    init(_ title: String) {
        self.title = title
        self.timestamp = Date()
    }
}

extension ComentorChat {
    @Transient
    var dialoguesArray: [Dialogue] {
        let set = dialogues
        return set.sorted { $0.timestamp < $1.timestamp }
    }
    
    @Transient
    var latestDialogue: Dialogue? {
        dialoguesArray.last
    }
}


