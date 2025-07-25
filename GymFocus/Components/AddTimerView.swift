//
//  AddTimerView.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 16/07/25.
//

import SwiftUI

struct AddTimerView : View {
    @EnvironmentObject private var settings: Settings
    @Environment(\.dismiss) var dismiss
    @State private var text: String = "45"
    @FocusState private var isFocused: Bool
    
    
    private let viewModel: ItemsViewModel
    
    init(_ viewModel: ItemsViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
                Text("time_in_seconds".localized("Time in seconds label")).font(.body1).padding()
                Spacer()
            }
            Spacer()
            TextField("seconds".localized("Seconds placeholder"), text: $text)
                .font(.primaryTitle)
                .focused($isFocused)
                .onAppear {
                    // Delay required for best UX, otherwise sometimes doesn't focus immediately
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isFocused = true
                    }
                }
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Spacer()
            PrimaryButton("add".localized("Add button")){
                viewModel.item.timers.append(Double(text) ?? 0)
                viewModel.item.timers.sort()
                dismiss()
            }
        }
        .padding()
    }
}

#Preview {
    AddTimerView(ItemsViewModel()).environmentObject(Settings())
}
