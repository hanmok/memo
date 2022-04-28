//
//  MemoBoxView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/29.
//

import SwiftUI

// used only to show, used in DraggableMemoBoxView
struct MemoBoxView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    
    @ObservedObject var memo: Memo
    
    var body: some View {
    
        return VStack(alignment: .leading, spacing: 5) {
            if memo.titleToShow != "" {
                Text(memo.titleToShow)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.blackAndWhite)
//                .foregroundColor(.black)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, Sizes.smallSpacing)
            }
            if memo.contentsToShow != "" {
                Text(memo.contentsToShow)
//                    .font(.caption)
                    .font(.footnote)
                    .foregroundColor(Color.blackAndWhite)
//                    .foregroundColor(.black)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, Sizes.smallSpacing)
            }
            
            HStack {
                Spacer()
                Text("\(memo.modificationDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption2)
//                    .foregroundColor(Color.blackAndWhite)
                    .foregroundColor(Color.gray).opacity(0.8)
            }
        }
        .padding(.horizontal, Sizes.smallSpacing)
        .padding(.vertical, Sizes.smallSpacing)
        .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding)
//        .background(Color.memoBoxColor)
//        .background(Color.testColor2)
//        .background(colorScheme == .dark ? Color.bgForDark : Color.testColor)
        .background(colorScheme == .dark ? Color.memoBoxColor : .newMemoBoxColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
//                .stroke(memoEditVM.selectedMemos.contains(memo) ? (colorScheme == .dark ? Color.cream : Color(white: 0.5)) : .clear, lineWidth: 1)
//                .stroke(memoEditVM.selectedMemos.contains(memo) ? (colorScheme == .dark ? Color.newMain3 : Color(white: 0.5)) : .clear, lineWidth: 1)
                .stroke(memoEditVM.selectedMemos.contains(memo) ? (colorScheme == .dark ? Color.newMain4 : Color(white: 0.5)) : .clear, lineWidth: 1)
        )
        .overlay(
            VStack {
                HStack(spacing: 6) {
                    Spacer()
//                    if memo.isBookMarked == true {
//                        SystemImage("bookmark.fill", size: 14)
//                            .tint(colorScheme == .dark ? Color.cream : .black)
//                    }
                    if memo.isPinned == true {
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

//struct RotatedPin: View {
//    var body: some View {
//        return Text(Image(systemName: "pin.fill").rotationEffect(.degrees(45)))
//    }
//}
