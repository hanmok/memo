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
                .foregroundColor(Color.lightMain)
                .background(Color.lightMain)
                .clipShape(Circle())
                .frame(width: 60, height: 60)

            SystemImage("plus")
                .frame(width: UIScreen.hasSafeBottom ? 30 : 25, height: UIScreen.hasSafeBottom ? 30 : 25)
                .foregroundColor(.black)
        }
    }
}


struct NewPlusImage: View {

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {

        ZStack {
//            SystemImage("circle", size: UIScreen.hasSafeBottom ? 50 : 40)
//            SystemImage("circle", size: 60)
//            Image(systemName: "circle")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 60, height: 60)
            
            Circle()
                .fill(
//                    RadialGradient(colors: colorScheme == .dark ?
////                                   [.white, Color.newMain3] :
//                                   [.darkMain, .darkMain] :
//                                   [.lightMain, .lightMain],
                    RadialGradient(colors:
//                                   [.white, Color.newMain3] :
                                   [.darkMain, .darkMain],
                                  
                                   center: .center, startRadius: 0, endRadius: 30))
                .frame(width: 60, height: 60)
                
            
//            SystemImage("circle", size: UIScreen.hasSafeBottom ? 60 : 50)
//                .foregroundColor(colorScheme == .dark ? Color.darkMain : Color.lightMain)
//                .background(colorScheme == .dark ? Color.darkMain : Color.lightMain)
//
//                .clipShape(Circle()
//                    .background(.clear)
//                )
//                .frame(width: 60, height: 60)

            SystemImage("plus")
                .frame(width: UIScreen.hasSafeBottom ? 30 : 25, height: UIScreen.hasSafeBottom ? 30 : 25)

//                .foregroundColor(colorScheme == .dark ? .black : .white)
                .foregroundColor(.black)
        }
    }
}




//struct NewPlusButton: View {
//
//    @Environment(\.colorScheme) var colorScheme: ColorScheme
//
//    var body: some View {
//
//        ZStack {
////            SystemImage("circle", size: UIScreen.hasSafeBottom ? 50 : 40)
//            SystemImage("circle", size: UIScreen.hasSafeBottom ? 60 : 50)
////                .foregroundColor(colorScheme == .dark ? Color.black : Color.subColor)
////                .background(colorScheme == .dark ? Color.black : Color.subColor)
//                .foregroundColor(colorScheme == .dark ? .newMain3 : .black)
////                .background(colorScheme == .dark ? .newMain3 : .black)
//                .background(colorScheme == .dark ? Color.newMain3 : .blue)
//                .clipShape(Circle())
//
////                .overlay(Circle()
////                            .stroke( Color.subColor, lineWidth: 3))
//
//
//            SystemImage("plus")
////                .frame(width: UIScreen.hasSafeBottom ? 25 : 18, height: UIScreen.hasSafeBottom ? 25 : 18)
//
//                .frame(width: UIScreen.hasSafeBottom ? 30 : 25, height: UIScreen.hasSafeBottom ? 30 : 25)
////                .foregroundColor(colorScheme == .dark ? Color.subColor : Color.black)
//                .foregroundColor(colorScheme == .dark ? .black : .white)
//        }
//    }
//}




