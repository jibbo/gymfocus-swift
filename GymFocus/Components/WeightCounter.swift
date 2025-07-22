//
//  WeightCounter.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 22/07/25.
//

import SwiftUI

struct WeightCounter: View {
    @State private var plates: [Double]
    
    @State private var sum: Double = 0
    
    private let supportedWeights: [Double: Color] = [1.25:.darkGray, 2.5:.gray, 5:.white, 10:.green, 15:.orange, 20:.blue, 25:.red]
    private let barWeight: Double = 20
    
    init(_ plates: [Double] = []) {
        self.plates = plates
        computeSum()
    }
    
    var body: some View {
        VStack {
            Text("Weights Counter")
                .font(.body1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Spacer()
            HStack{
                Spacer()
                if(!plates.isEmpty){
                    Rectangle().fill(Color.lightGray).frame(width:10, height: 30)
                }
                ForEach(plates.indices, id: \.self) { index in
                    displayPlate(plates[index]).onTapGesture {
                        plates.remove(at: index)
                        computeSum()
                    }
                }
                Rectangle().fill(Color.lightGray).frame(width:100, height: 30)
            }
            Spacer()
            HStack(alignment: .bottom){
                Text(String(sum)).font(.custom(Theme.fontName, size: 92).bold())
                Text("Kg").font(.body1).padding(.vertical)
            }
            Spacer()
            ScrollView(.horizontal){
                HStack{
                    ForEach(Array(supportedWeights.keys.sorted()), id: \.self){ key in
                        if(supportedWeights[key] == .white){
                            RoundButton(String(key), fillColor: supportedWeights[key], textColor: .black){
                                addPlate(key)
                            }
                        }else{
                            RoundButton(String(key), fillColor: supportedWeights[key]){
                                addPlate(key)
                            }
                        }
                    }
                }.onAppear{
                    plates.sort()
                    computeSum()
                }
            }
        }
    }
    
    private func addPlate(_ weight: Double) {
        plates.append(weight)
        plates.sort()
        computeSum()
    }
    
    private func displayPlate(_ weight: Double) -> some View{
        let height: CGFloat = weight <= 2.5 ? 50 : 90
        let width: CGFloat = weight <= 2.5 ? 10 : weight*2
        return Rectangle().fill(supportedWeights[weight] ?? Color.black).frame(width:width, height: height);
    }
    
    private func computeSum(){
        sum =  (plates.reduce(0, +)) * 2 + barWeight
    }
}

#Preview{
    WeightCounter([25,20,10,15,5,2.5,1.25])
}
