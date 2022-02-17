//
//  ColorTestView.swift
//  DeeepMemo
//
//  Created by 이한목 on 2022/02/17.
//

import SwiftUI
import CoreData

struct ColorPaletteView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedColorIndex: Int
    @Environment(\.presentationMode) var presentationMode
    @Binding var showColorPalette: Bool
    // How do I check Circle with checkMark here ??
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                ForEach(0 ... 4, id: \.self) {i in
                    Button {
                        selectedColorIndex = i
                        showColorPalette = false
                    } label: {
//                        Circle()
                        CircleWithTarget(targetIndex: selectedColorIndex, index: i, circleColor: Color.pastelColors[i], markColor: .black)
                    }
                        .frame(width: 24, height: 24)
//                        .foregroundColor(Color.pastelColors[i])
                }
            }
            
            HStack(spacing: 15) {
                ForEach(5 ... 9, id: \.self) {i in
                    Button {
                        selectedColorIndex = i
//                        presentationMode.wrappedValue.dismiss()
                        showColorPalette = false
                    } label: {
                        CircleWithTarget(targetIndex: selectedColorIndex, index: i, circleColor: Color.pastelColors[i], markColor: .black)
                    }
                        .frame(width: 24, height: 24)
                }
            }
            
            HStack(spacing: 15) {
                ForEach(10 ... 14, id: \.self) {i in
                    Button {
                        selectedColorIndex = i
//                        presentationMode.wrappedValue.dismiss()
                        showColorPalette = false
                    } label: {
                        CircleWithTarget(targetIndex: selectedColorIndex, index: i, circleColor: Color.pastelColors[i], markColor: .black)
                    }
                        .frame(width: 24, height: 24)
                }
            }
            
            
        }
        .padding()
//        .background(colorScheme.adjustMainColors())
        .background(Color(white: 0.8))
        .cornerRadius(10)
    }
}

//struct ColorTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorPaletteView()
//    }
//}



struct CircleWithTarget: View {
    var targetIndex: Int
    var index: Int
    var circleColor: Color
    var markColor: Color
    
    var body: some View {
        if targetIndex == index {
            ZStack {
                Circle()
                    .foregroundColor(circleColor)
                Image(systemName: "checkmark")
                    .foregroundColor(markColor)
            }
        } else{
            Circle()
                .foregroundColor(circleColor)
        }
    }
}
