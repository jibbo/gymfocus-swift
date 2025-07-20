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
            Text("")
                .navigationTitle("GymFocus")
            ViewThatFits(in: .horizontal){
                GeometryReader { proxy in
                    HStack{
                        SetsView(viewModel)
                            .frame(width: proxy.size.width * 0.3)
                        TimerView(viewModel)
                            .frame(width: proxy.size.width * 0.7)
                    }
                }.frame(minWidth: 400)
                TabView {
                    SetsView(viewModel).tabItem{
                        Image(systemName: "figure.gymnastics")
                        Text("Sets")
                    }
                    .padding()
                    TimerView(viewModel).tabItem{
                        Image(systemName: "clock")
                        Text("Timer")
                    }
                }
                .tint(Theme.primaryColor)
            }.onAppear(){
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


