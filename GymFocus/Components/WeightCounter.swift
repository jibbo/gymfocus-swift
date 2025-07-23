//
//  WeightCounter.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 22/07/25.
//

import SwiftUI

struct WeightCounter: View {
    @EnvironmentObject private var settings: Settings
    
    @State private var plates: [Double]
    
    @State private var sum: Double = 0
    
    private let supportedWeightsKg: [Double: Color] = [1.25:.darkGray, 2.5:.gray, 5:.white, 10:.green, 15:.orange, 20:.blue, 25:.red]
    private let supportedWeightsLbs: [Double: Color] = [2.2:.green, 3.3:.yellow, 4.4:.blue, 5.5:.red, 11:.white, 22:.green, 33:.yellow, 44: .blue, 55:.red]
    private let barWeightKg: Double = 20
    private let barWeightLbs: Double = 45
    
    init(_ plates: [Double] = []) {
        self.plates = plates
    }
    
    var body: some View {
        let unitMeasure = settings.metricSystem ? "Kg" : "lbs"
        VStack {
            Text("Weights Counter")
                .font(.body1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Spacer()
            barbellView(isKg: settings.metricSystem)
            Spacer()
            countView(unitMeasure)
            Spacer()
            platesPickerView(unitMeasure).padding()
        }
        .onAppear {
            computeSum(isKg: settings.metricSystem)
        }
    }
    
    private func addPlate(_ weight: Double) {
        plates.append(weight)
        plates.sort()
        computeSum(isKg: settings.metricSystem)
    }
    
    private func displayPlate(_ weight: Double, isKg: Bool = false) -> some View{
        let minWeight: Double = isKg ? 2.5 : 5.5
        let height: CGFloat = weight <= minWeight ? 50 : 90
        let width: CGFloat = weight <= minWeight ? 10 : weight*2
        return Rectangle().fill(supportedWeightsKg[weight] ?? Color.black).frame(width:width, height: height);
    }
    
    private func computeSum(isKg: Bool = false){
        let barWeight = isKg ? barWeightKg : barWeightLbs
        sum =  (plates.reduce(0, +)) * 2 + barWeight
    }
    
    private func plateText(_ weight: Double, unitMeasure: String = "Kg") -> String{
        if(weight.truncatingRemainder(dividingBy: 1) == 0 ){
            "\(String(Int(weight))) \(unitMeasure)"
        } else {
            "\(String(format: "%.2f", weight)) \(unitMeasure)"
        }
    }
    
    private func barbellView(isKg: Bool = false) -> some View{
        HStack{
            Spacer()
            if(!plates.isEmpty){
                Rectangle().fill(Color.lightGray).frame(width:10, height: 30)
            }
            ForEach(plates.indices, id: \.self) { index in
                displayPlate(plates[index], isKg: isKg).onTapGesture {
                    plates.remove(at: index)
                    computeSum()
                }
            }
            Rectangle().fill(Color.lightGray).frame(width:100, height: 30)
        }
    }
    
    private func countView(_ unitMeasure: String) -> some View{
        HStack(alignment: .bottom){
            Text(String(sum)).font(.custom(Theme.fontName, size: 92).bold())
            Text(unitMeasure).font(.body1).padding(.vertical)
        }
    }
    
    private func platesPickerView(_ unitMeasure: String) -> some View{
        ScrollView(.horizontal){
            HStack{
                ForEach(Array(supportedWeightsKg.keys.sorted()), id: \.self){ key in
                    if(supportedWeightsKg[key] == .white){
                        RoundButton(plateText(key, unitMeasure: unitMeasure), fillColor: supportedWeightsKg[key], textColor: .black){
                            addPlate(key)
                        }
                    }else{
                        RoundButton(plateText(key, unitMeasure: unitMeasure), fillColor: supportedWeightsKg[key]){
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

#Preview{
    WeightCounter([25,20,10,15,5,2.5,1.25]).environmentObject(Settings())
}
