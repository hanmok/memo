//
//  ColorPickerView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/17.
//

import SwiftUI

// MARK: - Color Picker View
struct ColorPickerView: View {
    @Binding var selectedIndex: Int
    
    init(selectedIndex: Binding<Int> = .constant(0)) {
        _selectedIndex = selectedIndex
    }
    var body: some View {
        ZStack {
            Circle()
                .stroke(.black, lineWidth: 2)
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
                .background(.white)
                .clipShape(Circle())
                
            ChangeableImage(imageSystemName: "circle")
                .frame(width: 16, height: 16)
                .background(Color.pastelColors[selectedIndex])
                .foregroundColor(Color.pastelColors[selectedIndex])
                .clipShape(Circle())
        }
    }
}
