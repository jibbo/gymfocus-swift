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
        VStack {
            Text("Weights Counter")
                .font(.body1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Spacer()
            barbellView(isKg: settings.metricSystem)
            Spacer()
            GeometryReader{ proxy in
                countView(settings.metricSystem, proxy: proxy)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }.frame(maxHeight:100)
            Spacer()
            platesPickerView(isKg: settings.metricSystem).padding()
            Spacer()
        }
        .onAppear {
            computeSum(settings.metricSystem)
        }
    }
    
    private func addPlate(_ weight: Double) {
        plates.append(weight)
        plates.sort()
        computeSum(settings.metricSystem)
    }
    
    private func displayPlate(_ weight: Double, isKg: Bool = false) -> some View{
        let minWeight: Double = isKg ? 2.5 : 5.5
        let height: CGFloat = weight <= minWeight ? 50 : 90
        let width: CGFloat = weight <= minWeight ? 10 : (isKg ? weight*2 : weight/1.5)
        let supportedWeights = isKg ? supportedWeightsKg : supportedWeightsLbs
        return Rectangle().fill(supportedWeights[weight] ?? Color.black).frame(width:width, height: height);
    }
    
    private func computeSum(_ isKg: Bool){
        let barWeight = isKg ? barWeightKg : barWeightLbs
        sum =  (plates.reduce(0, +)) * 2 + barWeight
    }
    
    private func getUnitMeasure(_ isKg: Bool) -> String{
        settings.metricSystem ? "Kg" : "lbs"
    }
    
    private func plateText(_ weight: Double, isKg: Bool) -> String{
        let unitMeasure = getUnitMeasure(isKg)
        if(weight.truncatingRemainder(dividingBy: 1) == 0 ){
            return "\(String(Int(weight))) \(unitMeasure)"
        } else {
            return "\(String(format: "%.2f", weight)) \(unitMeasure)"
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
                    computeSum(isKg)
                }
            }
            Rectangle().fill(Color.lightGray).frame(width:100, height: 30)
        }
    }
    
    private func countView(_ isKg: Bool = false, proxy: GeometryProxy) -> some View{
        HStack(alignment: .bottom){
            let fontSize:CGFloat = proxy.size.height>=500 ? 92 : 55
            Text(String(sum)).font(.custom(Theme.fontName, size: fontSize).bold())
            Text(getUnitMeasure(isKg)).font(.body1).padding(.vertical)
        }
    }
    
    private func platesPickerView(isKg: Bool) -> some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                let supportedWeights = isKg ? supportedWeightsKg : supportedWeightsLbs
                ForEach(Array(supportedWeights.keys.sorted()), id: \.self){ key in
                    if(supportedWeights[key] == .white || supportedWeights[key] == .yellow){
                        RoundButton(plateText(key, isKg: isKg), fillColor: supportedWeights[key], textColor: .black, size: 90 ){
                            addPlate(key)
                        }
                    }else{
                        RoundButton(plateText(key, isKg: isKg), fillColor: supportedWeights[key], textColor: .white, size: 90){
                            addPlate(key)
                        }
                    }
                }
            }.onAppear{
                plates.sort()
                computeSum(isKg)
            }
        }
    }
}

#Preview{
    WeightCounter().environmentObject(Settings())
}
