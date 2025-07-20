//
//  DesignSystem.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 16/07/25.
//

import SwiftUI


extension Font {
    static let primaryTitle: Font = .custom("BebasNeue-Regular", size: 42).bold()
    static let body: Font = .custom("BebasNeue-Regular", size: 22).bold()
}

enum Theme{
    static let primaryColor: Color = Color(red: 0.81, green: 1, blue: 0.01)
}

struct PrimaryButton: View {
    var title: String
    var action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("BebasNeue-Regular", size: 20))
                .bold()
                .foregroundColor(.black)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
        }
        .background(Theme.primaryColor)
        .cornerRadius(20)
        .frame(maxWidth: .infinity)
        .buttonStyle(DarkenOnTapButtonStyle())
    }
}

struct RoundButton : View{
    var title: String
    var dashed: Bool
    var action: ()->Void
    
    
    init(_ title: String, dashed: Bool = false,  action: @escaping ()->Void){
        self.title = title
        self.action = action
        self.dashed = dashed
    }
    
    var body: some View {
        Button(title){
            action()
        }
        .frame(minWidth:80)
        .padding(42)
        .font(.custom("BebasNeue-Regular", size: 20))
        .bold()
        .foregroundColor(.white)
        .clipShape(Circle())
        .overlay{
            if(dashed){
                Circle().stroke(Theme.primaryColor, style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
            }else{
                Circle().stroke(Theme.primaryColor, lineWidth: 2)
            }
        }
    }
}

struct DarkenOnTapButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed
                    ? Theme.primaryColor.darker(by: 0.2)
                    : Theme.primaryColor
            )
            .cornerRadius(20)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension Color {
    func darker(by percentage: CGFloat) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return Color(hue: hue, saturation: saturation, brightness: brightness * (1 - percentage), opacity: Double(alpha))
    }
}

#Preview {
    Text("Primary title").font(.primaryTitle)
    PrimaryButton("BUTTON"){
        
    }
    RoundButton("line"){
        
    }
    RoundButton("dashed", dashed: true){
        
    }
}
