//
//  ItemsViewModel.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 14/07/25.
//
import SwiftUI

final class ItemsViewModel: ObservableObject {
    @Published var item: Item = Item(steps: 0, timers: [])
}
