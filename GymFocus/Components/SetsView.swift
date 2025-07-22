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
            HStack(alignment: .bottom){
                Text(String(viewModel.item.steps))
                    .font(.custom("BebasNeue-Regular", size: 92).bold())
                Text("Sets completed")
                    .font(.body)
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
            }
        }
    }
}

#Preview {
    SetsView(ItemsViewModel())
}
