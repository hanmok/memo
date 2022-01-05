//
//  MemoBoxView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/29.
//

import SwiftUI

// used only to show.
struct MemoBoxView: View {
    
    var memo: Memo // has title, contents, overView(optional)
    
//    var overview: String? {
//        if  memo.overView != ""{
//            return memo.overView
//        }
//        return nil
//    }
    
    
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
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(5)
                
            }
            if memo.overview != "" {
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
        .frame(width: UIScreen.screenWidth / 2 - 1.5 * Sizes.overallPadding)
        .background(Color(white: 0.8))
        .cornerRadius(10)
    }
}

//struct MemoBoxView_Previews: PreviewProvider {
//
////    static let overViewSampleMemo = Memo( title: "Memo Sample", overView: "hello", contents: "sample contents", modifiedAt: Date())
//
//    //    static let sampleMemo = Memo( title: "Memo Sample", contents: "sample contents", modifiedAt: Date())
////    static let sampleMemo = Memo(title: "Memo Sample", overView: "sample overView", contents: "sample contents")
//
//    static var previews: some View {
//        MemoBoxView(memo:sampleMemo)
//            .previewLayout(.sizeThatFits)
//    }
//}
