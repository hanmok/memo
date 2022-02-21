//
//  MemoBoxView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/29.
//

import SwiftUI

// used only to show.
struct MemoBoxView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    
    @ObservedObject var memo: Memo
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            if memo.titleToShow != "" {
                Text(memo.titleToShow)
                .font(.headline)
                .fontWeight(.bold)
//                .foregroundColor(.primary)
                .foregroundColor(colorScheme.adjustInverseBlackAndWhite())
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, Sizes.smallSpacing)
            }
            if memo.contentsToShow != "" {
                Text(memo.contentsToShow)
                    .font(.caption)
//                    .foregroundColor(.primary)
                    .foregroundColor(colorScheme.adjustInverseBlackAndWhite())
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, Sizes.smallSpacing)
            }
        }
//        .tint(colorScheme == .dark ? Color(white: 228 / 255) : Color(white: 1))
        .tint(colorScheme.adjustInverseBlackAndWhite())
        .padding(.horizontal, Sizes.smallSpacing)
        .padding(.vertical, Sizes.smallSpacing)
        .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding)
//        .background(colorScheme.adjustSecondSubColors())
//        .background(Color.pastelColors[memo.colorIndex])

        .background(colorScheme.adjustMainColors())
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(memoEditVM.selectedMemos.contains(memo) ? (colorScheme == .dark ? .pink : .black) : .clear, lineWidth: 1)
        )
    }
}
