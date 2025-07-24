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
                }.tint(settings.getThemeColor())
                
                Toggle(isOn: $settings.singlePage){
                    Text("Single page mode")
                }.tint(settings.getThemeColor())
                
                Toggle(isOn: $settings.powerLifting){
                    Text("Power lifting mode")
                }.tint(settings.getThemeColor())
            }
            Section("Themes"){
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(Array(Theme.themes.keys.sorted()), id: \.self) { key in
                            ThemeButton(key, selected: settings.theme == key){
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
    private var selected: Bool
    private var action: () -> Void
    
    init(_ key: String, selected: Bool = false, action: @escaping () -> Void) {
        self.key = key
        self.color = Theme.themes[key] ?? .black
        self.action = action
        self.selected = selected
    }
    
    var body: some View {
        RoundButton(key, fillColor: color, size: 50){
            action()
        }
        .overlay{
            if(selected){
                Circle().stroke(.white, lineWidth: 4)
            }
        }
    }
}
