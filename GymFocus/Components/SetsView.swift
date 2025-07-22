//
//  SetsView.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 16/07/25.
//
import SwiftUI

struct SetsView: View {
    @ObservedObject private var viewModel: ItemsViewModel
    
    init(_ viewModel: ItemsViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Sets")
                .font(.body1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Spacer()
            HStack(alignment: .bottom){
                Text(String(viewModel.item.steps))
                    .font(.custom(Theme.fontName, size: 92).bold())
                Text("completed")
                    .font(.body1)
                    .padding(.vertical)
            }
            Spacer()
            HStack(spacing:5){
                PrimaryButton("RESET"){
                    viewModel.item.steps = 0
                }
                .frame(maxWidth: .infinity)
                PrimaryButton("+1"){
                    viewModel.item.steps += 1
                }.frame(maxWidth: .infinity)
            }.padding()
        }

    }
}

#Preview {
    SetsView(ItemsViewModel())
}
