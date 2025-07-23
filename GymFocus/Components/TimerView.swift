//
//  TimerView.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 18/07/25.
//

//
//  TimerView.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 16/07/25.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject private var viewModel: ItemsViewModel
    
    init(_ viewModel: ItemsViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            Text("Active Timer")
                .font(.body1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Spacer()
            CircularProgressView(progress: viewModel.timerProgress){
                Text(formatTime(Int(viewModel.timeRemaining)))
                    .font(.primaryTitle)
                    .opacity(viewModel.timerTextVisible ? 1 : 0)
                    .animation(.easeInOut(duration: viewModel.blinkDuration), value: viewModel.timerTextVisible)
            }.frame(minWidth:200, maxWidth: 300)
            SavedTimers(viewModel)
            Spacer()
            PrimaryButton("STOP"){
                viewModel.resetTimer();
            }.padding()
        }
        .fullScreenCover(isPresented: $viewModel.showNewTimer){
            AddTimerView(viewModel)
        }
        .alert(isPresented: $viewModel.showDeleteAlert) {
            Alert(title: Text("Delete Timer"), message: Text("Are you sure you want to delete this timer?"), primaryButton: .destructive(Text("Delete")) {
                viewModel.item.timers.remove(at: viewModel.item.timers.firstIndex(of: viewModel.selectedTimer)!)
            }, secondaryButton: .cancel())
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)){ _ in
            if(viewModel.timerRunning){
                Task { @MainActor in
                    let interval = viewModel.timerDate.timeIntervalSinceNow
                    if(interval <= 0){
                        viewModel.startBlinking()
                    }else{
                        viewModel.stopBlinking()
                    }
                    viewModel.timeRemaining = interval >= 0 ? interval : 0
                }
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
    
}

#Preview {
    let viewModel = ItemsViewModel();
    TimerView(viewModel).environmentObject(Settings()).onAppear {
        viewModel.item.timers=[30,60,90,120,180]
    }
}

