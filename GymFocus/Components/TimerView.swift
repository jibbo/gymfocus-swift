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
    @State private var timer: Timer? = nil
    @State private var timerRunning: Bool = false
    @State private var timeRemaining: Int = 0
    @State private var showNewTimer: Bool = false
    @State private var isBlinking = false
    @State private var visible = true
    @State private var timerDate = Date()
    
    private let blinkDuration = 0.2
    private let viewModel: ItemsViewModel
    private let alarmPlayer = AlarmPlayer()
    
    init(_ viewModel: ItemsViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            HStack{
                CircularProgressView(progress: 0.5)
                Text("Timer: ").font(.primaryTitle)
                Text(formatTime(timeRemaining))
                    .font(.primaryTitle)
                    .opacity(visible ? 1 : 0)
                    .animation(.easeInOut(duration: blinkDuration), value: visible)
            }
            ScrollView{
                FlowLayout(alignment: .center, spacing: 10){
                    ForEach(viewModel.item.timers, id: \.self){timer in
                        RoundButton(formatTime(timer)){
                            startTimer(time: timer)
                            stopBlinking()
                        }
                    }
                    RoundButton("+", dashed: true){
                        showNewTimer = true
                    }
                }
            }.onAppear{
                viewModel.item.timers.sort()
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)){ _ in
                if(timerRunning){
                    let interval = Int(timerDate.timeIntervalSinceNow)
                    if(interval <= 0){
                        startBlinking()
                    }else{
                        stopBlinking()
                    }
                    timeRemaining = interval >= 0 ? interval : 0
                }
            }
            HStack{
                PrimaryButton("STOP"){
                    alarmPlayer.stop()
                    resetTimer();
                    stopBlinking()
                }
            }
            .padding()
        }
        .sheet(isPresented: $showNewTimer){
            AddTimerView(viewModel)
        }
    }
    
    private func startTimer(time: Int) {
        timerRunning = true
        timer?.invalidate() // Invalidate any existing timer
        timeRemaining = time
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                timerRunning = false
                alarmPlayer.playSound(named: "digital_watch_alarm_long")
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                startBlinking()
            }
        }
        
        timerDate = Date().addingTimeInterval(Double(time))
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

#Preview {
    TimerView(ItemsViewModel())
}
