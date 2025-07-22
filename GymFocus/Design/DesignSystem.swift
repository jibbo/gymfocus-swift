//
//  DesignSystem.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 16/07/25.
//

import SwiftUI


enum Theme{
    static let fontName: String = "BebasNeue-Regular"
}

extension Font {
    static let primaryTitle: Font = .custom(Theme.fontName, size: 42)
    static let caption: Font = .custom(Theme.fontName, size: 32)
    static let buttons: Font = .custom(Theme.fontName, size: 20)
    static let body1: Font = .custom(Theme.fontName, size: 20)
    static let body2: Font = .custom(Theme.fontName, size: 16)
}

extension Color {
    static let primaryColor: Color = Color(red: 0.81, green: 1, blue: 0.01)
    static let lightGray: Color = Color(red: 0.63, green: 0.63, blue: 0.63)
    static let darkGray: Color = Color(red: 0.21, green: 0.21, blue: 0.21)
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
                .font(.buttons)
                .foregroundColor(.black)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
        }
        .background(Color.primaryColor)
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
                .font(.body2)
                .foregroundColor(.primaryColor)
        }
    }
}

struct RoundButton : View{
    var title: String
    var dashed: Bool
    var fillColor: Color?
    var textColor: Color
    var action: ()->Void
    let isEditMode: Bool
    
    
    init(_ title: String, dashed: Bool = false, fillColor: Color? = nil, textColor: Color = .white, isEditMode: Bool = false,  action: @escaping ()->Void){
        self.title = title
        self.action = action
        self.dashed = dashed
        self.isEditMode = isEditMode
        self.fillColor = fillColor
        self.textColor = textColor
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body1)
                .bold()
                .foregroundColor(textColor)
                .padding(50)
                .frame(maxWidth: .infinity)
                .background(fillColor != nil ? fillColor : Color.clear)
        }
        .frame(minWidth: 100, minHeight: 100)
        .clipShape(Circle())
        .overlay{
            let color: Color = isEditMode ? .red : .primaryColor
            if(fillColor == nil){
                if(dashed){
                    Circle().stroke(color, style: StrokeStyle(lineWidth: 2, dash: [8, 4])) .animation(.easeInOut(duration: 0.3), value: color)
                }else{
                    Circle().stroke(color, lineWidth: 2) .animation(.easeInOut(duration: 0.3), value: color)
                }
            }
        }
    }
}

struct DarkenOnTapButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed
                    ? Color.primaryColor.darker(by: 0.2)
                    : Color.primaryColor
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
    ScrollView(.horizontal){
        HStack{
            Text("primaryColor").background(Color.primaryColor).foregroundStyle(.black)
            Text("darkGray").background(Color.darkGray)
            Text("lightGray").background(Color.lightGray)
        }
    }
    Text("Primary title").font(.primaryTitle)
    Text("Caption").font(.caption)
    Text("body").font(.body)
    PrimaryButton("Primary"){
        
    }
    SecondaryButton("Secondary"){_ in
        
    }
    RoundButton("fill", fillColor: .red, textColor: .black){
        
    }
    RoundButton("line"){
        
    }
    RoundButton("dashed", dashed: true){
        
    }
}
