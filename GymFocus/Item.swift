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
    
    var timers: [Double]
    
    init(steps: Int, timers: [Double]) {
        self.steps = steps
        self.timers = timers
    }
}
