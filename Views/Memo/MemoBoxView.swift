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
                .foregroundColor(Color.blackAndWhite)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, Sizes.smallSpacing)
            }
            if memo.contentsToShow != "" {
//                Text("\n\(memo.contentsToShow)") // this line makes little error ..
//                Text("\n")
//                    .font(.caption)
                
//                    .font(.caption)
                Text(memo.contentsToShow)
                    .font(.caption)
                    .foregroundColor(Color.blackAndWhite)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, Sizes.smallSpacing)
            }
        }
        .padding(.horizontal, Sizes.smallSpacing)
        .padding(.vertical, Sizes.smallSpacing)
        .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding)
        .background(Color.memoBoxColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(memoEditVM.selectedMemos.contains(memo) ? (colorScheme == .dark ? Color.cream : Color(white: 0.5)) : .clear, lineWidth: 1)
        )
        .overlay(
            VStack {
                HStack(spacing: 6) {
                    Spacer()
                    if memo.isBookMarked == true {
                        SystemImage("bookmark.fill", size: 14)
                            .tint(colorScheme == .dark ? Color.cream : .black)
                    }
                    if memo.pinned == true {
                        SystemImage("pin.fill", size: 14)
                            .rotationEffect(.degrees(45))
                            .tint(colorScheme == .dark ? Color.cream : .black)
                    }
            }
                .padding(.trailing, Sizes.properSpacing)
                Spacer()
            }
                .padding(.top, Sizes.smallSpacing)
        )
    }
}
