//
//  PlusImage.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

struct PlusImage: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
//    var hasSafeBottom: Bool {
//        let scenes = UIApplication.shared.connectedScenes
//        let windowScene = scenes.first as? UIWindowScene
//        let window = windowScene?.windows.first
//        if (window?.safeAreaInsets.bottom)! > 0 {
//            print("has safeArea!")
//            return true
//        } else {
//            print("does not have safeArea!")
//            return false
//        }
//    }
    
    var body: some View {
        
        ZStack {
            SystemImage("circle", size: UIScreen.hasSafeBottom ? 50 : 40)
                .foregroundColor(colorScheme == .dark ? Color.black : Color.subColor)
                .background(colorScheme == .dark ? Color.black : Color.subColor)
                .clipShape(Circle())
                .overlay(Circle()
                            .stroke( Color.subColor, lineWidth: 3))
            
//            SystemImage("plus", size: hasSafeBottom ? 25 : 18)
            SystemImage("plus")
//            SystemImage("plus", size: hasSafeBottom ? 30 : 18)
                .frame(width: UIScreen.hasSafeBottom ? 25 : 18, height: UIScreen.hasSafeBottom ? 25 : 18)
                .foregroundColor(colorScheme == .dark ? Color.subColor : Color.black)
        }
    }
}





