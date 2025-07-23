//
//  DesignSystem.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 16/07/25.
//

import SwiftUI


extension Font {
    static let primaryTitle: Font = .custom(Theme.fontName, size: 42)
    static let caption: Font = .custom(Theme.fontName, size: 32)
    static let buttons: Font = .custom(Theme.fontName, size: 20)
    static let body1: Font = .custom(Theme.fontName, size: 20)
    static let body2: Font = .custom(Theme.fontName, size: 16)
}

extension Color {
    static let primaryGreen: Color = Color(red: 0.81, green: 1, blue: 0.01)
    static let primaryPurple: Color = Color(red: 0.533, green: 0, blue: 0.906)
    static let lightGray: Color = Color(red: 0.63, green: 0.63, blue: 0.63)
    static let darkGray: Color = Color(red: 0.21, green: 0.21, blue: 0.21)
}

enum Theme {
    static let fontName: String = "BebasNeue-Regular"
    static let themes: [String: Color] = ["green":.primaryGreen, "purple":.primaryPurple]
}

struct PrimaryButton: View {
    @EnvironmentObject private var settings: Settings

    var title: String
    var action: () -> Void
    var color: Color?
    
    init(_ title: String, color: Color? = nil, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.color = color
    }
    
    var body: some View {
        let themeColor = color ?? settings.getThemeColor()
        Button(action: action) {
            Text(title)
                .font(.buttons)
                .foregroundColor(.black)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
        }
        .background(themeColor)
        .cornerRadius(20)
        .frame(maxWidth: .infinity)
        .buttonStyle(DarkenOnTapButtonStyle(themeColor))
    }
}

struct SecondaryButton: View {
    @EnvironmentObject private var settings: Settings
    @State var title: String
    
    var color: Color?
    var action: (SecondaryButton) -> Void
    
    init(_ title: String, color: Color? = nil, action: @escaping (SecondaryButton) -> Void) {
        self.title = title
        self.action = action
        self.color = color
    }
    
    var body: some View {
        let themeColor = color ?? settings.getThemeColor()
        Button(action: {action(self)}) {
            Text(title)
                .font(.body2)
                .foregroundColor(themeColor)
        }
    }
}

struct RoundButton : View{
    @EnvironmentObject private var settings: Settings
    
    var color: Color?
    var title: String
    var dashed: Bool
    var fillColor: Color?
    var textColor: Color
    var action: ()->Void
    let isEditMode: Bool
    
    
    init(_ title: String, dashed: Bool = false, color: Color? = nil, fillColor: Color? = nil, textColor: Color = .white, isEditMode: Bool = false,  action: @escaping ()->Void){
        self.title = title
        self.action = action
        self.dashed = dashed
        self.isEditMode = isEditMode
        self.fillColor = fillColor
        self.textColor = textColor
        self.color = color
    }
    
    var body: some View {
        let themeColor = color ?? settings.getThemeColor()
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
            let innerColor: Color = isEditMode ? .red : themeColor
            if(fillColor == nil){
                if(dashed){
                    Circle().stroke(innerColor, style: StrokeStyle(lineWidth: 2, dash: [8, 4])) .animation(.easeInOut(duration: 0.4), value: innerColor)
                }else{
                    Circle().stroke(innerColor, lineWidth: 2) .animation(.easeInOut(duration: 0.4), value: innerColor)
                }
            }
        }
    }
}

struct DarkenOnTapButtonStyle: ButtonStyle {
    private var color: Color
    init(_ color: Color? = .primaryGreen) {
        self.color = color ?? .black
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed
                ? color.darker(by: 0.2)
                : color
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
    let settings = Settings()
    VStack{
        ScrollView(.horizontal){
            HStack{
                Text("primaryColor").background(Color.primaryGreen).foregroundStyle(.black)
                Text("primaryColor").background(Color.primaryPurple)
                Text("darkGray").background(Color.darkGray)
                Text("lightGray").background(Color.lightGray)
            }
        }
        Text("Primary").font(.primaryTitle)
        Text("Caption").font(.caption)
        Text("body").font(.body)
        PrimaryButton("Primary"){
            settings.theme = "purple"
        }
        SecondaryButton("Secondary"){_ in
            settings.theme = "green"
        }
        RoundButton("fill", fillColor: .red, textColor: .black){
            
        }
        RoundButton("line"){
            
        }
        RoundButton("dashed", dashed: true){
            
        }
    }.environmentObject(settings)
}
