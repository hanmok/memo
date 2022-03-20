//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct MemoList: View {
    
    @EnvironmentObject var folder: Folder
    
    var hasPinnedOrBookmarkedMemo: Bool {
        return folder.memos.contains { $0.isPinned == true || $0.isBookMarked == true}
    }
    
    // need to be modified to have plus button when there's no memo
    var body: some View {
        
//        var hasPinnedOrBookmarkedMemo: Bool {
//            return folder.memos.contains { $0.isPinned == true || $0.isBookMarked == true}
//        }
        
        return VStack {
            
            if hasPinnedOrBookmarkedMemo {
                
                FilteredMemoList(folder: folder, listType: .pinnedOrBookmarked)
                
                // line between pinned / unpinned memos
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(.sRGB, white: 0.85, opacity: 0.5))
                    .padding(.top, 5)
            }
            
            FilteredMemoList(folder: folder, listType: .plain)
        } // end of VStack
    }
}




