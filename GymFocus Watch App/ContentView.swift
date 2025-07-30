//
//  ContentView.swift
//  GymFocus Watch App
//
//  Created by Claude.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var timerManager = WatchTimerManager()
    
    var body: some View {
        TabView {
            // Sets Page (Left)
            SetsView(timerManager: timerManager)
                .tag(0)
            
            // Timer Page (Center)
            TimerView(timerManager: timerManager)
                .tag(1)
            
            // Timer Selection Page (Right)
            TimerSelectionView(timerManager: timerManager)
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .navigationTitle("GymFocus")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SetsView: View {
    @ObservedObject var timerManager: WatchTimerManager
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Sets")
                .font(.system(size: 22, weight: .bold))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("\(timerManager.currentSets)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(connectivityManager.themeColor)
            
            HStack(spacing: 20) {
                Button("-") {
                    timerManager.decrementSets()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .frame(width: 50, height: 50)
                
                Button("+") {
                    timerManager.incrementSets()
                }
                .buttonStyle(.borderedProminent)
                .tint(connectivityManager.themeColor)
                .foregroundStyle(connectivityManager.themeColor.textColor())
                .frame(width: 50, height: 50)
            }
            
            Text("Swipe for timer →")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct TimerView: View {
    @ObservedObject var timerManager: WatchTimerManager
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        ScrollView{
            VStack(spacing: 16) {
                Text("Rest Timer")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(timerManager.formattedTime)
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                    .foregroundColor(timerManager.isRunning ? connectivityManager.themeColor : .primary)
                
                VStack(spacing: 12) {
                    let color = timerManager.isRunning ? .red : connectivityManager.themeColor
                    Button(timerManager.isRunning ? "Stop" : "Start") {
                        if timerManager.isRunning {
                            timerManager.stopTimer()
                        } else {
                            timerManager.startTimer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(color)
                    .foregroundStyle(color.textColor())
                    .frame(maxWidth: .infinity)
                    
                    Button("Reset") {
                        timerManager.resetTimer()
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }
                
                HStack {
                    Text("← Sets")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Timer Settings →")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
}

struct TimerSelectionView: View {
    @ObservedObject var timerManager: WatchTimerManager
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Timer Duration")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.bottom, 8)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(connectivityManager.savedTimers, id: \.self) { duration in
                        Button(timerManager.formatTimerOption(duration)) {
                            timerManager.setTimerDuration(duration)
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(timerManager.selectedTimerDuration == duration ? connectivityManager.themeColor.opacity(0.3) : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(timerManager.selectedTimerDuration == duration ? connectivityManager.themeColor : Color.clear, lineWidth: 2)
                        )
                    }
                }
                
                Text("← Timer")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
