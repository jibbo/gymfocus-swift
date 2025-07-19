//
//  Item.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 14/07/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var steps: Int
    
    var timers: [Int]
    
    init(steps: Int, timers: [Int]) {
        self.steps = steps
        self.timers = timers
    }
}
