//
//  ItemsViewModel.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 14/07/25.
//
import SwiftUI
import AudioToolbox

final class ItemsViewModel: ObservableObject {
    @Published var item: Item = Item(steps: 0, timers: [])
    @Published var isEditing: Bool = false
    @Published var timer: Timer? = nil
    @Published var timerRunning: Bool = false
    @Published var timeRemaining: Double = 0
    @Published var timerDate = Date()
    @Published var timerProgress: Double = 0
    @Published var showNewTimer: Bool = false
    @Published var showDeleteAlert: Bool = false
    @Published var selectedTimer: Double = 0.0
    @Published var timerTextVisible = true
    @Published var isBlinking = false
    
    public let blinkDuration = 0.2
    
    
    private let alarmPlayer = AlarmPlayer()
    
    func startTimer(time: Double) {
        timerRunning = true
        timer?.invalidate() // Invalidate any existing timer
        timeRemaining = time
        timerProgress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.timerProgress = (time-self.timeRemaining)/time
            } else {
                self.timer?.invalidate()
                self.timerRunning = false
                self.alarmPlayer.playSound(named: "digital_watch_alarm_long")
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                self.startBlinking()
            }
        }
        
        self.timerDate = Date().addingTimeInterval(time)
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if(settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional) {
                self.scheduleTimerNotification(at: self.timerDate)
            } else{
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if(granted) {
                        self.scheduleTimerNotification(at: self.timerDate)
                    }
                }
            }
        }
        
    }
    
    func resetTimer() {
        timer?.invalidate()
        timeRemaining = 0
        timerRunning = false
        timerProgress = 0
        alarmPlayer.stop()
        stopBlinking()
    }
    
    func startBlinking() {
        guard !isBlinking else { return }
        isBlinking = true
        timerTextVisible = false
        Task {
            while isBlinking {
                try? await Task.sleep(nanoseconds: UInt64(blinkDuration * 1_000_000_000))
                if isBlinking { timerTextVisible.toggle() }
            }
        }
    }
    
    func stopBlinking() {
        isBlinking = false
        timerTextVisible = true
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
}
