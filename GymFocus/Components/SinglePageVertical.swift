//
//  SinglePageVertical.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 23/07/25.
//
import SwiftUI

struct SinglePageVertical: View {
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject private var viewModel: ItemsViewModel
    
    @SceneStorage("selectedTab") private var selectedTab: Int = 0
    
    init(_ viewModel: ItemsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ScrollView(showsIndicators:false){
                SetsView(viewModel)
                TimerView(viewModel)
                SavedTimers(viewModel)
            }
            .tabItem{
                Label(NSLocalizedString("sets", comment: "sets tab"), systemImage: "figure.strengthtraining.traditional")
            }
            .tag(0)
            WeightCounter()
                .tabItem{
                    Label(NSLocalizedString("plate_counter", comment: "Plate counter tab"), systemImage: "dumbbell")
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Label(NSLocalizedString("settings", comment: "Settings tab"), systemImage: "gearshape")
                }
                .tag(2)
        }
        .accentColor(settings.getThemeColor())
    }
}

#Preview {
    let viewModel = ItemsViewModel();
    SinglePageVertical(viewModel)
        .onAppear{
            viewModel.item.timers=[30,60,90,120,180]
        }
        .environmentObject(Settings())
}
