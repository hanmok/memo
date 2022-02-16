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

    @State var isSelected = false
    
    var title: String? {
        if memo.title != "" {
            return memo.title
        }
        return nil
    }
    
    var contents: String? {
        if memo.contents != "" {
            return memo.contents
        }
        return nil
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if title != nil {
                Text(memo.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(5)
            }
            if memo.overview != "" { // not using overview yet.
                Text(memo.overview)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
            } else {
                if memo.contents != "" {
                    Text(memo.contents)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .bottom], 5 )
                }
            }
        }
        .tint(colorScheme == .dark ? Color(white: 228 / 255) : Color(white: 1))
        .padding(.horizontal, Sizes.smallSpacing)
        .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding)
//        .background(colorScheme == .dark ? Color(white: 33 / 255) : Color(white: 0.9))
        .background(Color(.sRGB, red: 242 / 255, green: 206 / 255, blue: 128 / 255))
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(memoEditVM.selectedMemos.contains(memo) ? Color(UIColor(named: "mainColor")!) : .clear, lineWidth: 2)
        )
    }
}
