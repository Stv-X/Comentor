//
//  Item.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/9.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
