//
//  FilteredMemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/18.
//

import SwiftUI

struct FilteredMemoList: View {
   
//    @EnvironmentObject var memoVM: SelectedMemoViewModel
    
    var memos: [Memo] // 이거때문일듯 ??..
    var title: String
    let parent: Folder
    
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
                Text(title)
                    .foregroundColor(.gray)
                    .font(.body)
                    .frame(alignment: .topLeading)
                    .padding(.leading, Sizes.overallPadding)
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
