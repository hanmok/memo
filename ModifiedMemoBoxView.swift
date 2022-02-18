//
//  MemoBoxView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/29.
//

import SwiftUI

// used only to show.
struct ModifiedMemoBoxView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    
    @ObservedObject var memo: Memo
    
    // can both be nil? nope.
    // must have title.
    var title: String? {
        if let firstIndex = memo.contents.firstIndex(of: "\n") {
            // if no title entered, means memo starts with "\n"
            if firstIndex == memo.contents.index(memo.contents.startIndex, offsetBy: 0)  {
                return nil
            }
            
            let title = memo.contents[..<firstIndex]
            
            return String(title)
            // no "\n" entered.
        } else {
            return memo.contents
        }
    }
// 왜.. 중복이 생기지 ? 과거 데이터만 그러네..
    var contents: String? {
        if let firstEnterIndex = memo.contents.firstIndex(of: "\n") {
            let firstEnterIndexInt = memo.contents.distance(from: memo.contents.startIndex, to: firstEnterIndex)
            var numOfEnters = 0
//            let endIndexInt = memo.contents.distance(from: memo.contents.startIndex, to: memo.contents.endIndex) // == count

            while (memo.contents[memo.contents.index(memo.contents.startIndex, offsetBy: numOfEnters + firstEnterIndexInt)] == "\n" && numOfEnters + firstEnterIndexInt + 1 < memo.contents.count) {
                numOfEnters += 1
            }
            
            let startIndex = memo.contents.index(memo.contents.startIndex, offsetBy: numOfEnters + firstEnterIndexInt)
            let endIndex = memo.contents.endIndex
            
            let contents = memo.contents[startIndex ..< endIndex]
            return String(contents)
        }
        return nil
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            if title != nil {
            Text(title!)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, Sizes.smallSpacing)
            }
            if contents != nil {
                Text(contents!)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, Sizes.smallSpacing)
            }
        }
        .tint(colorScheme == .dark ? Color(white: 228 / 255) : Color(white: 1))
        .padding(.horizontal, Sizes.smallSpacing)
        .padding(.vertical, Sizes.smallSpacing)
        .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding)
//        .background(colorScheme.adjustSecondSubColors())
        .background(Color.pastelColors[memo.colorIndex])
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(memoEditVM.selectedMemos.contains(memo) ? .black : .clear, lineWidth: 1)
        )
    }
}
