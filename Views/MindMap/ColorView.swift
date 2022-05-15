//
//  ColorView.swift
//  DeeepMemo (iOS)
//
//  Created by 이한목 on 2022/05/15.
//

import SwiftUI

struct ColorView: View {
//    @Binding private var red: Double
//    @Binding private var green: Double
//    @Binding private var blue: Double
    
    @State private var red: Double = 0
    @State private var green: Double = 0
    @State private var blue: Double = 0
//    @State private var shouldHide = false
    
//    private func toggleHidden() {
//        shouldHide.toggle()
//    }
    
    var body: some View {
        VStack {
//            HStack {
//            Button(action: toggleHidden) {
//                Text("btn")
//            }
            
//                if !shouldHide {
            Rectangle().frame(width: 100, height: 50)
                .background(Color(red: red / 255, green: green / 255, blue: blue / 255))
                .foregroundColor(Color(red: red / 255, green: green / 255, blue: blue / 255))
//                }
//            }
//            if !shouldHide {
            Text("\(Int(red)), \(Int(green)), \(Int(blue))")
            Slider(value: $red, in: 0...255, step: 1)
            Slider(value: $green, in: 0...255, step: 1)
            Slider(value: $blue, in: 0...255, step: 1)
//            }
            Spacer()
        }
        .background(.white)
        .frame(width: 150, height: 200)
    }
}


struct BindedColorView: View {
    
    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double
    
    var body: some View {
        VStack {
            Rectangle().frame(width: 100, height: 50)
                .background(Color(red: red / 255, green: green / 255, blue: blue / 255))
                .foregroundColor(Color(red: red / 255, green: green / 255, blue: blue / 255))
            Text("\(Int(red)), \(Int(green)), \(Int(blue))")
            Slider(value: $red, in: 0...255, step: 1)
            Slider(value: $green, in: 0...255, step: 1)
            Slider(value: $blue, in: 0...255, step: 1)
            Spacer()
        }
        .background(.white)
        .frame(width: 150, height: 200)
    }
}

struct BindedColor: View {
    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double
    
    var body: some View {
        return Rectangle()
            .frame(width: 100, height: 50)
            .foregroundColor(Color(red: red / 255, green: green / 255, blue: blue / 255))
            .background(Color(red: red / 255, green: green / 255, blue: blue / 255))
    }
}
