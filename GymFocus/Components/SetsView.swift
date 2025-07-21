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
            Spacer()
            VStack{
                Text(String(viewModel.item.steps)).font(.primaryTitle)
                Text("Sets completed").font(.body)
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
            }
        }
    }
}

#Preview {
    SetsView(ItemsViewModel())
}
