//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI


struct MemoList: View {
    
    //    @Environment(\.managedObjectContext) var context
    //    @StateObject var selectedViewModel = SelectedMemoViewModel()
    
    @EnvironmentObject var folder: Folder
    //    @ObservedObject var folder: Folder
//    @Binding var isAddingMemo: Bool
//    @Binding var isSpeading: Bool
    @ObservedObject var pinViewModel : PinViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel

    func makeNewMemo() {
//        isAddingMemo = true
        memoEditVM.shouldAddMemo = true
    }
    
    var memoColumns: [GridItem] {
        [GridItem(.flexible(minimum: 150, maximum: 200)),
         GridItem(.flexible(minimum: 150, maximum: 200))
        ]
    }
    
    //    var pinnedMemos: [Memo] {
    //        //        memos.filter {$0.pinned}
    //        let sortedOldMemos = folder.memos.sorted()
    //        return sortedOldMemos.filter {$0.pinned}
    //    }
    
    //    var unpinnedMemos: [Memo] {
    //        //        memos.filter { !$0.pinned}
    //        let sortedOldMemos = folder.memos.sorted()
    //        return sortedOldMemos.filter {!$0.pinned}
    //    }
    
    //    @State var memoSelected: Bool = false
    //    @ObservedObject var memos: [Memo]
    
    var memos: [Memo] {
        let sortedOldMemos = folder.memos.sorted()
        
        return sortedOldMemos
    }
    
    // need to be modified to have plus button when there's no memo
    var body: some View {
        
        return VStack {
            VStack {
                if pinViewModel.pinnedMemos.count != 0 {
                    FilteredMemoList(memos: pinViewModel.pinnedMemos, title: "pinned", parent: folder)
                    // cross line between pinned / unpinned memos
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(.sRGB, white: 0.85, opacity: 0.5))
                }
                FilteredMemoList(memos: pinViewModel.unpinnedMemos, title: "unpinned", parent: folder)
            } // end of VStack
            
            // end of current memo
            
            

            
                
                
        }
      
    }
}


//struct MemoList_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoList(folder: deeperFolder)
//    }
//}
