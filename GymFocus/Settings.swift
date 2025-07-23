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

    init() {
        self.theme = UserDefaults.standard.string(forKey: "theme") ?? Theme.themes.keys.first!
    }
    
    func getThemeColor() -> Color {
        return Theme.themes[theme] ?? .green
    }
}
