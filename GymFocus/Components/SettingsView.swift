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
                .onChange(of: settings.metricSystem) { oldValue, newValue in
                    let bars = settings.metricSystem ? settings.barsKg : settings.barsLbs
                    settings.selectedBar = bars.last ?? 0
                }
                .tint(settings.getThemeColor())
                
                Toggle(isOn: $settings.singlePage){
                    Text("Single page mode")
                }.tint(settings.getThemeColor())
                
                Toggle(isOn: $settings.powerLifting){
                    Text("Weigth Percentage calculator")
                }.tint(settings.getThemeColor())
                
            }
            Section("Themes"){
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(Array(Theme.themes.map(\.key)), id: \.self) { key in
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
        self.color = Theme.themes.first(where: { $0.key == key })?.color ?? .primaryDefault

        self.action = action
        self.selected = selected
    }
    
    var body: some View {
        RoundButton("", fillColor: color, size: 45){
            action()
        }
        .overlay{
            if(selected){
                Circle().stroke(.white, lineWidth: 4)
            }
        }
    }
}
