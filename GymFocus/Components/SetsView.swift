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
            HStack{
                Text("Sets done: ").font(.primaryTitle)
                Text(String(viewModel.item.steps)).font(.primaryTitle)
            }
            HStack{
                PrimaryButton("RESET"){
                    viewModel.item.steps = 0
                }
                PrimaryButton("+1"){
                    viewModel.item.steps += 1
                }
            }
        }
    }
}

#Preview {
    SetsView(ItemsViewModel())
}
