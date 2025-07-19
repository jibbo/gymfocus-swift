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

//let linearGradient: LinearGradient = LinearGradient(
//    gradient: Gradient(colors: [Color(red: 0.6, green: 1.2, blue: 0.0),
//                                Color(red: 0.2, green: 0.2, blue: 1.3)]),
//    startPoint: .topLeading,
//    endPoint: .bottomTrailing
//)

struct PrimaryButton : View{
    var title: String
    var action: ()->Void
    
    init(_ title: String, action: @escaping ()->Void){
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(title){
            action()
        }
        .padding(30)
        .foregroundColor(.black)
        .background(Theme.primaryColor)
        .cornerRadius(20)
        .font(.custom("BebasNeue-Regular", size: 20))
        .bold()
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

#Preview {
    Text("Primary title").font(.primaryTitle)
    PrimaryButton("BUTTON"){
        
    }
    RoundButton("line"){
        
    }
    RoundButton("dashed", dashed: true){
        
    }
}
