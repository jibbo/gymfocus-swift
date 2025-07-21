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

struct SecondaryButton: View {
    @State var title: String
    var action: (SecondaryButton) -> Void

    init(_ title: String, action: @escaping (SecondaryButton) -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: {action(self)}) {
            Text(title)
                .font(.custom("BebasNeue-Regular", size: 16))
                .bold()
                .foregroundColor(Theme.primaryColor)
                .padding(.vertical, 16)
        }
    }
}

struct RoundButton : View{
    var title: String
    var dashed: Bool
    var action: ()->Void
    let isEditMode: Bool
    
    
    init(_ title: String, dashed: Bool = false, isEditMode: Bool = false,  action: @escaping ()->Void){
        self.title = title
        self.action = action
        self.dashed = dashed
        self.isEditMode = isEditMode
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("BebasNeue-Regular", size: 20))
                .bold()
                .foregroundColor(.white)
                .padding(50)
                .frame(maxWidth: .infinity)
        }
        .frame(minWidth: 100, minHeight: 100)
        .clipShape(Circle())
        .overlay{
            let color: Color = isEditMode ? .red : Theme.primaryColor
            if(dashed){
                Circle().stroke(color, style: StrokeStyle(lineWidth: 2, dash: [8, 4])) .animation(.easeInOut(duration: 0.3), value: color)
            }else{
                Circle().stroke(color, lineWidth: 2) .animation(.easeInOut(duration: 0.3), value: color)
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
    PrimaryButton("Primary"){
        
    }
    SecondaryButton("Secondary"){_ in
        
    }
    RoundButton("line"){
        
    }
    RoundButton("dashed", dashed: true){
        
    }
}
