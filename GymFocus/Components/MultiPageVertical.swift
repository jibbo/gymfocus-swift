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
    
    @SceneStorage("selectedTab") private var selectedTab: Int = 0
    
    init(_ viewModel: ItemsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView{
            SetsView(viewModel).tabItem {
                Label("Sets", systemImage: "gauge.with.needle")
            }
            ScrollView(showsIndicators: false){
                TimerView(viewModel)
                SavedTimers(viewModel)
            }.tabItem {
                Label("Timer", systemImage: "clock")
            }.tag(0)
            WeightCounter()
                .tabItem{
                    Label("Plates Counter", systemImage: "figure.strengthtraining.traditional")
                }.tag(1)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
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
