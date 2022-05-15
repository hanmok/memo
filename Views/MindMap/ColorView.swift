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
    
    
    var body: some View {
        VStack {
            Slider(value: $red, in: 0...255, step: 1)
            Slider(value: $green, in: 0...255, step: 1)
            Slider(value: $blue, in: 0...255, step: 1)
            Text("red: \(red), green: \(green), blue: \(blue)")
            
            Rectangle().frame(width: 100, height: 100)
                .background(Color(red: red / 255, green: green / 255, blue: blue / 255))
                .foregroundColor(Color(red: red / 255, green: green / 255, blue: blue / 255))
        }
    }
}
