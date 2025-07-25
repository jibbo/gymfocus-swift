//
//  GymFocusWidgetsBundle.swift
//  GymFocusWidgets
//
//  Created by Giovanni De Francesco on 25/07/25.
//

import WidgetKit
import SwiftUI
import ActivityKit

struct TimerActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var timeRemaining: Double
        var totalDuration: Double
        var isRunning: Bool
        var endTime: Date
    }
    
    var timerName: String
    var themeColorRed: Double
    var themeColorGreen: Double
    var themeColorBlue: Double
}

extension Color {
    init(red: Double, green: Double, blue: Double) {
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }
}

struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            let themeColor = Color(
                red: context.attributes.themeColorRed,
                green: context.attributes.themeColorGreen,
                blue: context.attributes.themeColorBlue
            )
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "timer")
                        .foregroundColor(themeColor)
                    Text("Rest Time")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(formatTime(Int(context.state.timeRemaining)))
                        .font(.title2)
                        .foregroundColor(.white)
                        .monospacedDigit()
                }
                
                ProgressView(value: context.state.timeRemaining / context.state.totalDuration)
                    .progressViewStyle(LinearProgressViewStyle(tint: themeColor))
                    .frame(height: 4)
            }
            .padding()
            .background(Color.black)
            .cornerRadius(12)
        } dynamicIsland: { context in
            let themeColor = Color(
                red: context.attributes.themeColorRed,
                green: context.attributes.themeColorGreen,
                blue: context.attributes.themeColorBlue
            )
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: "timer")
                            .foregroundColor(themeColor)
                        Text("Rest Time")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(formatTime(Int(context.state.timeRemaining)))
                        .font(.title2)
                        .foregroundColor(.white)
                        .monospacedDigit()
                }
                DynamicIslandExpandedRegion(.center) {
                    ProgressView(value: context.state.timeRemaining / context.state.totalDuration)
                        .progressViewStyle(LinearProgressViewStyle(tint: themeColor))
                        .frame(height: 4)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Rest Timer")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } compactLeading: {
                Image(systemName: "timer")
                    .foregroundColor(themeColor)
            } compactTrailing: {
                Text(formatTime(Int(context.state.timeRemaining)))
                    .font(.caption2)
                    .foregroundColor(themeColor)
                    .monospacedDigit()
            } minimal: {
                Image(systemName: "timer")
                    .foregroundColor(themeColor)
            }
            .widgetURL(URL(string: "gymfocus://timer"))
            .keylineTint(.clear)
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}

@main
struct GymFocusWidgetsBundle: WidgetBundle {
    var body: some Widget {
        TimerLiveActivity()
    }
}
