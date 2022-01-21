//
//  MemoBoxView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/29.
//

import SwiftUI

// used only to show.
struct MemoBoxView: View {
    
//    @EnvironmentObject var selectedVM: SelectedMemoViewModel
    // navigation 과 연관지어주어야 그냥 클릭을 했을 때도 잘 될 것 같은데 ?
    
//    var memo: Memo // has title, contents, overView(optional)
    @ObservedObject var memo: Memo
    
//    var overview: String? {
//        if  memo.overView != ""{
//            return memo.overView
//        }
//        return nil
//    }
    
//    @State var pressedLong = false
    
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
//        .frame(width: UIScreen.screenWidth / 2 - 1.5 * Sizes.overallPadding)
        .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding)
        .background(Color(white: 0.8))
        .border(isSelected ? .red : .clear , width: 3)
        .cornerRadius(5)
//        .onTapGesture {
//            print("onTapGesture on MemoBoxView triggered1")
//            if selectedVM.memos.contains(self.memo) {
//                selectedVM.memos.remove(self.memo)
//                self.isSelected = false
//            } else {
//                if selectedVM.count != 0 {
////                    selectedVM.memos.update(with: self.memo)
//                    selectedVM.add(memo: self.memo)
//                    self.isSelected = true
//                }
//                print("onTapGesture on MemoBoxView triggered2")
//            }
//            selectedVM.hasSelected = selectedVM.count != 0
//        }
//        .disabled(!selectedVM.hasSelected)
        
//        .onLongPressGesture {
//
//            if !selectedVM.memos.contains(self.memo) {
//                selectedVM.add(memo: self.memo)
//                self.isSelected = true
//            } else {
//                selectedVM.memos.remove(self.memo)
//                self.isSelected = false
//            }
//            // if any selected, hasSelected is true
//            selectedVM.hasSelected = selectedVM.count != 0
//
//            print("self is pressed long, \(self)")
//        }
        // navigation 이랑 겹침.. ;;
        
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
