//
//  CircularProgressView.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 18/07/25.
//

import SwiftUI

struct CircularProgressView: View {
    var progress: Double
    var lineWidth: CGFloat
    var color: Color
    var content: (()->any View)?
    
    init(progress: Double = 0, lineWidth: CGFloat = 10, color: Color = .green, content: (()-> any View)? = nil) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.color = color
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(Int(progress * 100))%")
                            .font(.headline)
                            .bold()
        }.padding()
    }
}

#Preview {
    CircularProgressView(progress: 0.5){
        Text("Hello")
    }
}
