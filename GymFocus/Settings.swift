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

    init() {
        self.theme = UserDefaults.standard.string(forKey: "theme") ?? "S"
        self.metricSystem = UserDefaults.standard.bool(forKey: "metricSystem")
        self.singlePage = UserDefaults.standard.bool(forKey: "singlePage")
    }
    
    func getThemeColor() -> Color {
        return Theme.themes[theme] ?? .green
    }
}
