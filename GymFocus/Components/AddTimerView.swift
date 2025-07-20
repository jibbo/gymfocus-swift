//
//  AddTimerView.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 16/07/25.
//

import SwiftUI

struct AddTimerView : View {
    @Environment(\.dismiss) var dismiss
    @State private var text: String = "45"
    @FocusState private var isFocused: Bool
    
    
    private let viewModel: ItemsViewModel
    
    init(_ viewModel: ItemsViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            Text("Time in seconds:").font(.body).padding()
            Spacer()
            TextField("seconds", text: $text)
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
            HStack{
                Spacer()
                PrimaryButton("Cancel"){
                    dismiss()
                }
                PrimaryButton("Add"){
                    viewModel.item.timers.append(Double(text) ?? 0)
                    viewModel.item.timers.sort()
                    dismiss()
                }
            }
        }
        .padding()
    }
}

#Preview {
    AddTimerView(ItemsViewModel())
}
