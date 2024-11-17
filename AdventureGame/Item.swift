//
//  Item.swift
//  AdventureGame
//
//  Created by Conner Yoon on 11/17/24.
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
