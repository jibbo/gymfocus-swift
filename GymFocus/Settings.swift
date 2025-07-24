//
//  Settings.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 23/07/25.
//

import Foundation
import SwiftUI

final class Settings: ObservableObject {
    @Published var theme: String {
        didSet {
            UserDefaults.standard.set(theme, forKey: "theme")
        }
    }
    
    @Published var metricSystem: Bool {
        didSet {
            UserDefaults.standard.set(metricSystem, forKey: "metricSystem")
        }
    }
    
    @Published var singlePage: Bool {
        didSet {
            UserDefaults.standard.set(singlePage, forKey: "singlePage")
        }
    }
    
    @Published var powerLifting: Bool {
        didSet {
            UserDefaults.standard.set(powerLifting, forKey: "powerLifting")
        }
    }
    
    let barsKg: [Int] = [7, 10, 15, 20]
    let barsLbs: [Int] = [15, 35, 45]
    
    @Published var selectedBar: Int {
        didSet {
            UserDefaults.standard.set(selectedBar, forKey: "selectedBar")
        }
    }

    init() {
        self.theme = UserDefaults.standard.string(forKey: "theme") ?? "S"
        self.metricSystem = UserDefaults.standard.bool(forKey: "metricSystem")
        self.singlePage = UserDefaults.standard.bool(forKey: "singlePage")
        self.powerLifting = UserDefaults.standard.bool(forKey: "powerLifting")
        self.selectedBar = (UserDefaults.standard.integer(forKey: "selectedBar") > 0) ? UserDefaults.standard.integer(forKey: "selectedBar") : ((UserDefaults.standard.bool(forKey: "metricSystem") ? barsKg.last : barsLbs.last) ?? 20)
    }
    
    func getThemeColor() -> Color {
        return Theme.themes[theme] ?? .green
    }

}
