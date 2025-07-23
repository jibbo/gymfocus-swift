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
                Label("Sets", systemImage: "gauge.with.needle")
            }
            ScrollView{
                TimerView(viewModel)
                SavedTimers(viewModel)
            }.tabItem {
                Label("Timer", systemImage: "clock")
            }
            WeightCounter()
            .tabItem{
                Label("Plates Counter", systemImage: "figure.strengthtraining.traditional")
            }
            SettingsView().tabItem {
                Label("Settings", systemImage: "gearshape")
            }
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
