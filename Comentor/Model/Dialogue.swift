//
//  Dialogue.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//
//

import Foundation
import SwiftData


@Model
final class Dialogue {
    var dialogueIdentifier: UUID
    var ask: String
    var answer: String = ""
    var timestamp: Date
    var success: Bool = true
    
    var chat: ComentorChat?
    
    init(_ ask: String) {
        self.ask = ask
        self.dialogueIdentifier = UUID()
        self.timestamp = Date()
    }
}
