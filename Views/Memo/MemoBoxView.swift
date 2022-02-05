//
//  MemoBoxView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/29.
//

import SwiftUI

// used only to show.
struct MemoBoxView: View {
    
    @ObservedObject var memo: Memo
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var isSelected = false
    
    var title: String? {
        if memo.title != "" {
            return memo.title
        }
        return nil // empty Title
    }
    
    var contents: String? {
        if memo.contents != "" {
            return memo.contents
        }
        return nil // empty contents
    }
    
    
    // If both overview exist, contents doesn't show up
    // if overview doesn't only title and contents show up
    
    var body: some View {
        VStack(alignment: .leading) {
            if title != nil {
                Text(memo.title)
                //                .font(.title2)
//                    .font(.title3)
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .bottom], 5 )
                    
                }
            }
        }
        .tint(colorScheme == .dark ? Color(white: 228 / 255) : Color(white: 1))
        .padding(.horizontal, Sizes.smallSpacing)
        .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding)
//        .background(Color(white: 0.95))
        .background(colorScheme == .dark ? Color(white: 33 / 255) : Color(white: 0.9))
        .border(memoEditVM.selectedMemos.contains(memo) ? .green : .clear , width: 1)
        .cornerRadius(5)
    }
}
