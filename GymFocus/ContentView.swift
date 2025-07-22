//
//  ContentView.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 14/07/25.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ItemsViewModel = ItemsViewModel()
    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack{
            ViewThatFits(in: .horizontal){
                GeometryReader { proxy in
                    HStack{
                        SetsView(viewModel)
                            .frame(width: proxy.size.width * 0.3)
                        TimerView(viewModel)
                            .frame(width: proxy.size.width * 0.5)
                        SavedTimers(viewModel).frame(width: proxy.size.width * 0.2)
                    }
                }
                .frame(minWidth: 500)
                ScrollView(showsIndicators:false){
                    SetsView(viewModel)
                    TimerView(viewModel)
                    SavedTimers(viewModel)
                }
            }
            .navigationTitle("Gym Focus".uppercased())
            .onAppear(){
                if items.isEmpty {
                    let newItem = Item(steps: 0, timers: [30, 60, 120, 180])
                    modelContext.insert(newItem)
                    viewModel.item = newItem
                } else {
                    viewModel.item = items[0]
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
