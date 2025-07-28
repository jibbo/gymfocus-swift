//
//  Planner.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 26/07/25.
//

import SwiftUI

struct WorkoutPlanView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var workoutViewModel: WorkoutPlanViewModel = WorkoutPlanViewModel()
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
            if(workoutViewModel.workoutPlanItem.workoutPlanJson.isEmpty){
                Image(systemName: "ecg.text.page").font(.system(size: 300)).foregroundStyle(.primary.opacity(0.8))
                PrimaryButton("add".localized("adds a workout plan")){
                    showAddWorkoutPlanSheet = true
                }.padding()
            }else {
                ScrollView{
                    Text(workoutViewModel.workoutPlanItem.workoutPlanJson)
                }.padding()
            }
            Spacer()
        }.sheet(isPresented: $showAddWorkoutPlanSheet){
            CreateManualPlanView(workoutViewModel)
//            PlanFromCamera(workoutViewModel)
        }
        .onAppear{
            workoutViewModel.loadWorkoutPlan(from: modelContext)
        }
    }
}

#Preview {
    WorkoutPlanView().environmentObject(Settings())
}
