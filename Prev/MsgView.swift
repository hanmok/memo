//
//  MsgView.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/13.
//

import SwiftUI

// this view need to have property of seconds
// animation: opacity
// position: determined from parent View

struct MsgView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var msgToShow: String?
    let duration: Double = 1.0
    @State var isShowingMsg = false


    var body: some View {
        if msgToShow != nil {
            Text(msgToShow!)
                .font(.body)
//                .foregroundColor(.green)
                .frame(alignment: .center)
                .padding(Sizes.smallSpacing)
//                .background(RoundedRectangle(cornerRadius: 10)
//                                .foregroundColor(.gray))
                .background(colorScheme == .dark ? Color.init(white: 0.1) : Color.subColor)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ? Color.cream : Color(white: 0.8)))
                .opacity(isShowingMsg ? 1 : 0)
                .animation(.easeInOut(duration: duration).speed(2.0), value: isShowingMsg)
                .onAppear {
                    isShowingMsg = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isShowingMsg = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        msgToShow = nil
                    }
                }
        } else {
            EmptyView()
        }
    }
}
