//
//  SettingsView.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 23/07/25.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: Settings
    
    var body: some View {
        Form{
            Section("Settings"){
                Toggle(isOn: $settings.metricSystem){
                    Text("Use metric system")
                }
                
                Toggle(isOn: $settings.singlePage){
                    Text("Single page mode")
                }
            }
            Section("Theme"){
                ScrollView(.horizontal){
                    HStack{
                        ForEach(Array(Theme.themes.keys), id: \.self) { key in
                            ThemeButton(key){
                                settings.theme = key
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let settings = Settings()
    SettingsView()
        .environmentObject(settings)
}

struct ThemeButton: View {
    private var key: String
    private var color: Color
    private var action: () -> Void
    
    init(_ key: String, action: @escaping () -> Void) {
        self.key = key
        self.color = Theme.themes[key] ?? .black
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Circle().fill(color)
                    .frame(width: 60, height: 60)
            }
        }
        .clipShape(Circle())
        .buttonStyle(DarkenOnTapButtonStyle(color))
    }
}
