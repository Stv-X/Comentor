//
//  Dialogue.swift
//  Comentor Watch App
//
//  Created by 徐嗣苗 on 2023/6/12.
//

import Foundation
import SwiftData


@Model
final class Dialogue {
    var ask: String
    var answer: String = ""
    var timestamp: Date
    var success: Bool = true
    
    var chat: ComentorChat?
    
    init(_ ask: String) {
        self.ask = ask
        self.timestamp = Date()
    }
}

