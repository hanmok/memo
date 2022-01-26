//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI


struct SubMemoList: View {
    
    //    @Environment(\.managedObjectContext) var context
    //    @StateObject var selectedViewModel = SelectedMemoViewModel()
    
    @EnvironmentObject var folder: Folder
    //    @ObservedObject var folder: Folder
    //    @Binding var isAddingMemo: Bool
    //    @Binding var isSpeading: Bool
    //    @ObservedObject var pinViewModel : PinViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    
    
    
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
    
    
    // need to be modified to have plus button when there's no memo
    var body: some View {
        
        let subFolders = folder.subfolders.sorted()
//        let hasMemo = subFolders.fir
        
        
        return VStack {
            
//            if !subFolders.isEmpty {
//                Group {
//                    Rectangle()
//                        .frame(height: 0.5)
//                        .foregroundColor(Color(.sRGB, white: 0, opacity: 1))
//                        .padding(.horizontal, Sizes.overallPadding)
//                        .padding(.top, Sizes.overallPadding * 2)
//
//                    Text("Memos contained in SubFolders")
//
//                    Rectangle()
//                        .frame(height: 0.5)
//                        .foregroundColor(Color(.sRGB, white: 0, opacity: 1))
//                        .padding(.horizontal, Sizes.overallPadding)
//                        .padding(.bottom, Sizes.overallPadding)
//                }
//            }
            
            
            
            ForEach(subFolders) { subFolder in
                
                if subFolder.memos.count != 0 {
                    NavigationLink {
                        FolderView(currentFolder: subFolder)
                            .environmentObject(memoEditVM)
                            .environmentObject(folderEditVM)
                    } label: {
                        HStack {
                            Text(subFolder.title)
                                .padding(.leading, Sizes.overallPadding)
                            
                            Spacer()
                        }
                    }
                    
                    FilteredMemoList(memos: subFolder.returnAllMemos().memos, title: "ignore", parent: subFolder)
                    
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(.sRGB, white: 0.85, opacity: 0.5))
                }
            }
        }
    }
}


//struct MemoList_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoList(folder: deeperFolder)
//    }
//}
