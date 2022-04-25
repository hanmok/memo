//
//  PlusImage.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

struct PlusImage: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        
        ZStack {
            SystemImage("circle", size: UIScreen.hasSafeBottom ? 50 : 40)
//                .foregroundColor(colorScheme == .dark ? Color.black : Color.subColor)
//                .background(colorScheme == .dark ? Color.black : Color.subColor)
                .foregroundColor(Color.newMain)
                .background(Color.newMain)
                .clipShape(Circle())
                
//                .overlay(Circle()
//                            .stroke( Color.subColor, lineWidth: 3))
                    
            
            SystemImage("plus")
                .frame(width: UIScreen.hasSafeBottom ? 25 : 18, height: UIScreen.hasSafeBottom ? 25 : 18)
//                .foregroundColor(colorScheme == .dark ? Color.subColor : Color.black)
                .foregroundColor(.black)
        }
    }
}


struct RadialPlusImage: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        
        ZStack {
//            SystemImage("circle", size: UIScreen.hasSafeBottom ? 50 : 40)
            Circle()
                .fill(
                    RadialGradient(colors: [.white, Color.newMain], center: .center, startRadius: 0, endRadius: 25))
                .frame(width: 50, height: 50)
//                .foregroundColor(colorScheme == .dark ? Color.black : Color.subColor)
//                .background(colorScheme == .dark ? Color.black : Color.subColor)
//                .foregroundColor(Color.newMain)
//                .background(Color.newMain)
//                .clipShape(Circle())
//                .radial
//                .overlay(Circle()
//                            .stroke( Color.subColor, lineWidth: 3))
                    
            
            SystemImage("plus")
                .frame(width: UIScreen.hasSafeBottom ? 25 : 18, height: UIScreen.hasSafeBottom ? 25 : 18)
//                .foregroundColor(colorScheme == .dark ? Color.subColor : Color.black)
                .foregroundColor(.black)
        }
    }
}
