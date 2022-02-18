//
//  ColorTestView.swift
//  DeeepMemo
//
//  Created by 이한목 on 2022/02/17.
//

import SwiftUI
import CoreData

struct ColorPaletteView: View {
    // closure should be here ?
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedColorIndex: Int
    @Environment(\.presentationMode) var presentationMode
    @Binding var showColorPalette: Bool
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @Environment(\.managedObjectContext) var context
    @GestureState var isScrolled = false
    // How do I check Circle with checkMark here ??
    
    init(selectedColorIndex: Binding<Int> = .constant(-1), showColorPalette: Binding<Bool>) {
        _selectedColorIndex = selectedColorIndex
        _showColorPalette = showColorPalette
    }
    var body: some View {
        let scroll = DragGesture(minimumDistance: 5, coordinateSpace: .local)
            .updating($isScrolled) { _, _, _ in
                DispatchQueue.main.async {
                showColorPalette = false
                }
            }
        
        return VStack {
            HStack(spacing: 15) {
                ForEach(0 ... 4, id: \.self) {i in
                    Button {

                        _ = memoEditVM.selectedMemos.map { $0.colorIndex = i}
                        context.saveCoreData()
                        selectedColorIndex = i
//                        memoEditVM.initSelectedMemos()
                        memoEditVM.selectedMemos.removeAll()
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
                        _ = memoEditVM.selectedMemos.map { $0.colorIndex = i}
                        
                        context.saveCoreData()
//                        memoEditVM.initSelectedMemos()
                        memoEditVM.selectedMemos.removeAll()
                        selectedColorIndex = i

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
                        _ = memoEditVM.selectedMemos.map { $0.colorIndex = i}
                        context.saveCoreData()
//                        memoEditVM.initSelectedMemos()
                        memoEditVM.selectedMemos.removeAll()
                        selectedColorIndex = i
                        showColorPalette = false
                    } label: {
                        CircleWithTarget(targetIndex: selectedColorIndex, index: i, circleColor: Color.pastelColors[i], markColor: .black)
                    }
                        .frame(width: 24, height: 24)
                }
            }
        }
        .gesture(scroll)
        .padding(15)
        .background(Color(white: 0.8))
        .cornerRadius(10)
    }
}


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
