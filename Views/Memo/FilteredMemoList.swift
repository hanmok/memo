//
//  FilteredMemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/18.
//

import SwiftUI

struct FilteredMemoList: View {
   
//    @EnvironmentObject var memoVM: SelectedMemoViewModel
    
    var memos: [Memo]
    var title: String
    let parent: Folder
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        Section {
            ForEach(memos, id: \.self) { memo in
                
//                if !memoVM.hasSelected {
                    NavigationLink(destination: MemoView(memo: memo, parent: parent)) {
                        MemoBoxView(memo: memo)
//                            .frame(width: 170, alignment: .topLeading)
                            .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                    }
            }
        } header: {
            HStack {
                if title == "pinned" {
                    ChangeableImage(imageSystemName: "pin.fill", width: 16, height: 16)
                        .frame(alignment: .topLeading)
                        .rotationEffect(.degrees(45))
                        .padding(.leading, Sizes.overallPadding + 4)
                }
                else if title == "unpinned" {
                    
                } else if title == "ignore" {
                    
                }
                else {
                    Text(title)
                        .foregroundColor(colorScheme.adjustTint())
                        .font(.body)
                        .frame(alignment: .topLeading)
                        .padding(.leading, Sizes.overallPadding)
                }
                
                Spacer()
            }
        }
    }
}

//struct FilteredMemoList_Previews: PreviewProvider {
//    static var previews: some View {
//        FilteredMemoList()
//    }
//}
