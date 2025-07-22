//
//  SavedTimers.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 22/07/25.
//

import SwiftUI

struct SavedTimers: View {
    @ObservedObject private var viewModel: ItemsViewModel
    
    init(_ viewModel: ItemsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View{
        ViewThatFits(in: .horizontal){
            GeometryReader { proxy in
                FlowLayout(spacing: 10){
                    generateSavedTimers()
                }
            }
            .frame(minWidth: 200)
            VStack{
                generateSavedTimers()
            }
        }
    }
    
    private func generateSavedTimers() -> some View {
        Group{
            ForEach(viewModel.item.timers.indices, id: \.self) { index in
                let timer = viewModel.item.timers[index]
                // Use a tuple as the id so SwiftUI knows to re-render on edit mode change
                let buttonID = "\(timer)-\(viewModel.isEditing)"
                RoundButton(
                    formatTime(Int(timer)),
                    isEditMode: viewModel.isEditing
                ) {
                    if viewModel.isEditing {
                        viewModel.showDeleteAlert = true
                        viewModel.selectedTimer = timer
                    } else {
                        viewModel.startTimer(time: timer)
                        viewModel.stopBlinking()
                    }
                }
                .id(buttonID)
            }
            if(!viewModel.isEditing){
                RoundButton("+", dashed: true){
                    viewModel.showNewTimer = true
                }
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
