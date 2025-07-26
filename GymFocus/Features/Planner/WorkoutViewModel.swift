//
//  WorkoutViewModel.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 26/07/25.
//

import SwiftUI

final class WorkoutViewModel: ObservableObject{
    @Published var workoutPlanItem: WorkoutPlanItem? = nil
    
    func workOutAsString() -> String {
        (try? JSONEncoder().encode(workoutPlanItem?.plan)).flatMap { String(data: $0, encoding: .utf8) } ?? ""
    }
}
