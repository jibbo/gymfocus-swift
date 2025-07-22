//
//  HeaderView.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 22/07/25.
//

import SwiftUI
struct HeaderView: View {
    private var viewModel: ItemsViewModel
    init(_ viewModel: ItemsViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        HStack(alignment: .bottom){
            Text("Gym Focus").font(.primaryTitle)
            Spacer()
            SecondaryButton(viewModel.isEditing ? "Done": "Edit"){ it in
                viewModel.isEditing.toggle()
                it.title = viewModel.isEditing ? "Done": "Edit"
            }.padding(.vertical, 10)
        }
    }
}


#Preview {
    HeaderView(ItemsViewModel())
}
