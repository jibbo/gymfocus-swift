//
//  Planner.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 26/07/25.
//

import SwiftUI

struct PlannerView: View {
    @ObservedObject var workoutViewModel: WorkoutViewModel = WorkoutViewModel()
    @State var showAddWorkoutPlanSheet: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                SectionTitle("plan".localized("plan section title"))
                SecondaryButton("add".localized("adds a workout plan")){ _ in
                    showAddWorkoutPlanSheet = true
                }
            }
            Spacer()
            Image(systemName: "ecg.text.page").font(.system(size: 300)).foregroundStyle(.primary.opacity(0.8))
            if(workoutViewModel.workoutPlanItem != nil){
                PrimaryButton("add".localized("adds a workout plan")){
                    showAddWorkoutPlanSheet = true
                }.padding()
            }else {
                Text(workoutViewModel.workOutAsString())
            }
            Spacer()
        }.sheet(isPresented: $showAddWorkoutPlanSheet){
            PlanFromCamera(workoutViewModel)
        }
    }
}

#Preview {
    PlannerView().environmentObject(Settings())
}
