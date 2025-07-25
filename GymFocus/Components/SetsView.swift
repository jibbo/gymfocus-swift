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
                Text(NSLocalizedString("sets", comment: "Sets label"))
                    .font(.body1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Spacer()
                SecondaryButton(NSLocalizedString("reset", comment: "Reset button")){_ in
                    viewModel.item.steps = 0
                }
            }
            Spacer()
            HStack(alignment: .bottom){
                Text(String(viewModel.item.steps))
                    .font(.custom(Theme.fontName, size: 92).bold())
                Text(NSLocalizedString("completed", comment: "Completed label"))
                    .font(.body1)
                    .padding(.vertical)
            }
            Spacer()
            PrimaryButton(NSLocalizedString("plus_one", comment: "+1 button")){
                viewModel.item.steps += 1
            }
            .padding()
        }
    }
}

#Preview {
    SetsView(ItemsViewModel()).environmentObject(Settings())
}
