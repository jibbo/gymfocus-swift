//
//  SinglePageVertical.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 23/07/25.
//
import SwiftUI

struct ContentHorizontal: View {
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject private var viewModel: ItemsViewModel
    
    private var proxy: GeometryProxy
    
    init(_ viewModel: ItemsViewModel, geometryProxy: GeometryProxy) {
        self.viewModel = viewModel
        self.proxy = geometryProxy
    }
    
    var body: some View {
        TabView{
            WorkoutPlanView().tabItem {
                Label("plan".localized(), systemImage: "ecg.text.page")
            }.tag(0)
            HStack{
                SetsView(viewModel)
                    .frame(width: proxy.size.width * 0.3)
                TimerView(viewModel)
                    .frame(width: proxy.size.width * 0.5)
                SavedTimers(viewModel).frame(width: proxy.size.width * 0.2)
            }.tabItem{
                Label("sets".localized("sets tab"), systemImage: "figure.strengthtraining.traditional")
            }.tag(1)
            WeightCounter().tabItem{
                    Label("plates_counter".localized("Plates counter tab"), systemImage: "dumbbell")
                }.tag(1)
            SettingsView().tabItem {
                    Label("settings".localized("Settings tab"), systemImage: "gearshape")
                }.tag(2)
        }
        .accentColor(settings.getThemeColor())
    }
}

#Preview {
    let viewModel = ItemsViewModel();
    GeometryReader { proxy in
        ContentHorizontal(viewModel, geometryProxy: proxy)
    }
    .onAppear{
        viewModel.item.timers=[30,60,90,120,180]
    }
    .environmentObject(Settings())
}
