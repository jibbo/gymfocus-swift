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
            Section(NSLocalizedString("unit_of_measure", comment: "Unit of Measure section")){
                Toggle(isOn: $settings.metricSystem){
                    Text(NSLocalizedString("use_metric_system", comment: "Use metric system toggle"))
                }
                .onChange(of: settings.metricSystem) { oldValue, newValue in
                    let bars = settings.metricSystem ? settings.barsKg : settings.barsLbs
                    settings.selectedBar = bars.last ?? 0
                }
                .tint(settings.getThemeColor())
            }
            Section(NSLocalizedString("advanced", comment: "Advanced section")){
                Toggle(isOn: $settings.singlePage){
                    Text(NSLocalizedString("single_page_mode", comment: "Single page mode toggle"))
                }.tint(settings.getThemeColor())
            }
            Section(NSLocalizedString("experimental_features", comment: "Experimental Features section")){
                Toggle(isOn: $settings.powerLifting){
                    Text(NSLocalizedString("weight_percentage_calculator", comment: "Weight Percentage calculator toggle"))
                }.tint(settings.getThemeColor())
            }
            Section(NSLocalizedString("themes", comment: "Themes section")){
                ScrollView(showsIndicators: false){
                    FlowLayout{
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
