//
//  SinglePageVertical.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 23/07/25.
//
import SwiftUI

struct MultiPageVertical: View {
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject private var viewModel: ItemsViewModel
    
    init(_ viewModel: ItemsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView{
            SetsView(viewModel).tabItem {
                Label(NSLocalizedString("sets", comment: "Sets tab"), systemImage: "figure.strengthtraining.traditional")
            }
            ScrollView(showsIndicators: false){
                TimerView(viewModel)
                SavedTimers(viewModel)
            }.tabItem {
                Label(NSLocalizedString("timer", comment: "Timer tab"), systemImage: "clock")
            }.tag(0)
            WeightCounter()
                .tabItem{
                    Label(NSLocalizedString("plates_counter", comment: "Plates Counter tab"), systemImage: "dumbbell")
                }.tag(1)
            SettingsView()
                .tabItem {
                    Label(NSLocalizedString("settings", comment: "Settings tab"), systemImage: "gearshape")
                }.tag(2)
        }.accentColor(settings.getThemeColor())
    }
}

#Preview {
    let viewModel = ItemsViewModel();
    MultiPageVertical(viewModel)
        .onAppear{
            viewModel.item.timers=[30,60,90,120,180]
        }
        .environmentObject(Settings())
}
