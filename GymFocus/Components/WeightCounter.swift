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
    @State private var maxKg: String = "20"
    @State private var percent: String = "70"
    @State private var weightLeft: String = "0"
    @State private var showWeightAlert: Bool = false
    
    private let supportedWeightsKg: [Double: Color] = [0.25:.gray, 1: .gray, 1.25:.darkGray, 2.5:.darkGray, 5:.white, 10:.green, 15:.orange, 20:.blue, 25:.red]
    private let supportedWeightsLbs: [Double: Color] = [0.25:.darkGray, 0.5:.darkGray, 0.75:.darkGray, 1:.darkGray, 2.5:.darkGray, 5:.darkGray, 10:.white, 15:.yellow, 20:.blue, 25:.green, 35:.orange, 45: .blue, 55:.red]
    private let barWeightKg: Double = 20
    private let barWeightLbs: Double = 45
    
    init(_ plates: [Double] = []) {
        self.plates = plates
    }
    
    var body: some View {
        ScrollView{
            VStack {
                if(settings.powerLifting){
                    powerLifintMode()
                }
                Group{
                    Text("Barbell")
                        .font(.body1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    Spacer()
                    barbellView()
                    Spacer()
                    GeometryReader{ proxy in
                        countView(proxy: proxy)
                            .frame(width: proxy.size.width, height: proxy.size.height)
                    }.frame(maxHeight:100)
                    Spacer()
                    platesPickerView().padding()
                    Spacer()
                }.frame(minHeight: 50)
            }
            .onAppear {
                computeSum()
            }
            .alert(isPresented: $showWeightAlert) {
                Alert(title: Text("This weight can't be added to the bar"), message: Text("\(weightLeft) \(getUnitMeasure())"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func powerLifintMode() -> some View{
        VStack{
            Text("Power lifting mode")
                .font(.body1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            HStack {
                HStack(spacing: 1) { // adjust spacing if needed
                    TextField("One Rep Max", text: $maxKg)
                        .font(.primaryTitle)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: maxKg) { _, newValue in
                            automaticPlates(newValue, percent)
                        }
                    Text(settings.metricSystem ? "Kg": "Lbs")
                        .font(.body2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 1) {
                    TextField("%", text: $percent)
                        .font(.primaryTitle)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: percent) { _, newValue in
                            automaticPlates(maxKg, newValue)
                        }
                    Text("%")
                        .font(.body2)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
        }
    }
    
    private func automaticPlates(_ value: String, _ percent: String){
        let barWeight = settings.metricSystem ? barWeightKg : barWeightLbs
        let percent = Double(percent) ?? 100
        let weight = (Double(value) ?? 0) * (percent/100)
        let weightPerSide = (weight - barWeight) / 2
        
        plates.removeAll()
        
        // Impossible if target is less than bar weight or not divisible by 2
        if weightPerSide < barWeight {
            // TODO show error alert
            return
        }
        
        var remaining = weightPerSide
        
        let availablePlates = settings.metricSystem ? supportedWeightsKg.keys.sorted{$0>$1} : supportedWeightsLbs.keys.sorted{$0>$1}
        for plate in availablePlates {
            while remaining >= plate - 0.001 { // use a tolerance for floating point
                plates.append(plate)
                remaining -= plate
            }
        }
        
        plates.sort()
        
        computeSum()
    }
    
    private func addPlate(_ weight: Double) {
        plates.append(weight)
        plates.sort()
        computeSum()
    }
    
    private func displayPlate(_ weight: Double) -> some View{
        let minWeight: Double = settings.metricSystem ? 2.5 : 5.5
        let height: CGFloat = weight <= minWeight ? 50 : 90
        let width: CGFloat = weight <= minWeight ? 10 : (settings.metricSystem ? weight*2 : weight/1.5)
        let supportedWeights = settings.metricSystem ? supportedWeightsKg : supportedWeightsLbs
        return Rectangle().fill(supportedWeights[weight] ?? Color.black).frame(width:width, height: height);
    }
    
    private func computeSum(){
        let barWeight = settings.metricSystem ? barWeightKg : barWeightLbs
        sum =  (plates.reduce(0, +)) * 2 + barWeight
    }
    
    private func getUnitMeasure() -> String{
        settings.metricSystem ? "Kg" : "lbs"
    }
    
    private func plateText(_ weight: Double) -> String{
        let unitMeasure = getUnitMeasure()
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
                displayPlate(plates[index]).onTapGesture {
                    plates.remove(at: index)
                    computeSum()
                }
            }
            Rectangle().fill(Color.lightGray).frame(width:100, height: 30)
        }
    }
    
    private func countView(proxy: GeometryProxy) -> some View{
        HStack(alignment: .bottom){
            let fontSize:CGFloat = proxy.size.height>=500 ? 92 : 55
            Text(String(sum)).font(.custom(Theme.fontName, size: fontSize).bold())
            Text(getUnitMeasure()).font(.body1).padding(.vertical)
        }
    }
    
    private func platesPickerView() -> some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                let supportedWeights = settings.metricSystem ? supportedWeightsKg : supportedWeightsLbs
                ForEach(Array(supportedWeights.keys.sorted()), id: \.self){ key in
                    if(supportedWeights[key] == .white || supportedWeights[key] == .yellow){
                        RoundButton(plateText(key), fillColor: supportedWeights[key], textColor: .black, size: 90 ){
                            addPlate(key)
                        }
                    }else{
                        RoundButton(plateText(key), fillColor: supportedWeights[key], textColor: .white, size: 90){
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
    let settings = Settings()
    WeightCounter().environmentObject(settings).onAppear {
        settings.metricSystem = true
        settings.powerLifting = true
    }
}
