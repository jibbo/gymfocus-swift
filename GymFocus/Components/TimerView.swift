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
import AudioToolbox

struct TimerView: View {
    @ObservedObject private var viewModel: ItemsViewModel
    @State private var timer: Timer? = nil
    @State private var timerRunning: Bool = false
    @State private var timeRemaining: Double = 0
    @State private var visible = true
    @State private var timerDate = Date()
    @State private var timerProgress: Double = 0
    @State private var isBlinking = false
    @State private var showNewTimer: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var selectedTimer: Double = 0.0
    
    private let blinkDuration = 0.2
    private let alarmPlayer = AlarmPlayer()
    
    init(_ viewModel: ItemsViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { proxy in
            if(proxy.size.height > 400){
                VStack{
                    EditView(viewModel)
                    CircularProgressView(progress: timerProgress){
                        Text(formatTime(Int(timeRemaining)))
                            .font(.primaryTitle)
                            .opacity(visible ? 1 : 0)
                            .animation(.easeInOut(duration: blinkDuration), value: visible)
                    }
                    .frame(minHeight: 200)
                    
                    ScrollView(.horizontal, showsIndicators: true){
                        displaySavedTimers();
                    }
                    .onAppear{
                        viewModel.item.timers.sort()
                    }.onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)){ _ in
                        if(timerRunning){
                            let interval = timerDate.timeIntervalSinceNow
                            if(interval <= 0){
                                startBlinking()
                            }else{
                                stopBlinking()
                            }
                            timeRemaining = interval >= 0 ? interval : 0
                        }
                    }
                    .padding()
                    PrimaryButton("STOP"){
                        alarmPlayer.stop()
                        resetTimer();
                        stopBlinking()
                    }
                    .padding()
                }
            } else {
                VStack{
                    EditView(viewModel)
                    HStack(alignment:.center){
                        CircularProgressView(progress: timerProgress){
                            Text(formatTime(Int(timeRemaining)))
                                .font(.primaryTitle)
                                .opacity(visible ? 1 : 0)
                                .animation(.easeInOut(duration: blinkDuration), value: visible)
                        }
                        PrimaryButton("STOP"){
                            alarmPlayer.stop()
                            resetTimer();
                            stopBlinking()
                        }
                        .frame(maxWidth: 150)
                    }
                    ScrollView(.horizontal, showsIndicators: true){
                        displaySavedTimers()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showNewTimer){
            AddTimerView(viewModel)
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text("Delete Timer"), message: Text("Are you sure you want to delete this timer?"), primaryButton: .destructive(Text("Delete")) {
                viewModel.item.timers.remove(at: viewModel.item.timers.firstIndex(of: selectedTimer)!)
            }, secondaryButton: .cancel())
        }
    }
    
    private func startTimer(time: Double) {
        timerRunning = true
        timer?.invalidate() // Invalidate any existing timer
        timeRemaining = time
        timerProgress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                timerProgress = (time-timeRemaining)/time
            } else {
                timer?.invalidate()
                timerRunning = false
                alarmPlayer.playSound(named: "digital_watch_alarm_long")
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                startBlinking()
            }
        }
        
        timerDate = Date().addingTimeInterval(time)
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if(settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional) {
                scheduleTimerNotification(at: timerDate)
            } else{
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if(granted) {
                        scheduleTimerNotification(at: timerDate)
                    }
                }
            }
        }
        
    }
    
    private func displaySavedTimers() -> some View {
        HStack(spacing: 10){
            ForEach(viewModel.item.timers.indices, id: \.self) { index in
                let timer = viewModel.item.timers[index]
                // Use a tuple as the id so SwiftUI knows to re-render on edit mode change
                let buttonID = "\(timer)-\(viewModel.isEditing)"
                RoundButton(
                    formatTime(Int(timer)),
                    isEditMode: viewModel.isEditing
                ) {
                    if viewModel.isEditing {
                        showDeleteAlert = true
                        selectedTimer = timer
                    } else {
                        startTimer(time: timer)
                        stopBlinking()
                    }
                }
                .id(buttonID) // 👈 This is the key!
            }
            if(!viewModel.isEditing){
                RoundButton("+", dashed: true){
                    showNewTimer = true
                }
            }
        }
    }
    
    private func scheduleTimerNotification(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Time's up!"
        content.body = "Yeah buddy! Light weight!"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timeRemaining = 0
        timerRunning = false
        timerProgress = 0
    }
    
    private func formatTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
    
    private func startBlinking() {
        guard !isBlinking else { return }
        isBlinking = true
        visible = false
        Task {
            while isBlinking {
                try? await Task.sleep(nanoseconds: UInt64(blinkDuration * 1_000_000_000))
                if isBlinking { visible.toggle() }
            }
        }
    }
    
    private func stopBlinking() {
        isBlinking = false
        visible = true
    }
}

struct EditView: View {
    private var viewModel: ItemsViewModel
    
    init(_ viewModel: ItemsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack{
            Spacer()
            SecondaryButton(viewModel.isEditing ? "Done": "Edit"){ it in
                viewModel.isEditing.toggle()
                it.title = viewModel.isEditing ? "Done": "Edit"
            }.padding()
        }
    }
}


#Preview {
    let viewModel = ItemsViewModel();
    TimerView(viewModel).onAppear{
        viewModel.item.timers=[30,60,90,120,180]
    }
}

