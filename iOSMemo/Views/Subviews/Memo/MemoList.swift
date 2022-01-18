//
//  MemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI


class SelectedMemoViewModel: ObservableObject {
    
    @Published var memos = Set<Memo>()
    
    @Published var hasSelected = false
    
    public var count: Int {
        memos.count
    }
    
    func add(memo: Memo) {
        self.memos.update(with: memo)    }
}



struct MemoList: View {
    
    @Environment(\.managedObjectContext) var context
    @StateObject var selectedViewModel = SelectedMemoViewModel()
    
    @EnvironmentObject var folder: Folder
//    @ObservedObject var folder: Folder
    @Binding var isAddingMemo: Bool
    
    //    @State var selectedMemos: [Memo] = []
    
    //    @Binding var selectedMemo: Memo?
    
    //    var memoColumns: [GridItem] {
    //        [GridItem(.adaptive(minimum: 100, maximum: 150))]
    //    }
    
    var memoColumns: [GridItem] {
        [GridItem(.flexible(minimum: 150, maximum: 200)),
         GridItem(.flexible(minimum: 150, maximum: 200))
        ]
    }
    
    var pinnedMemos: [Memo] {
        //        memos.filter {$0.pinned}
        let sortedOldMemos = folder.memos.sorted()
        return sortedOldMemos.filter {$0.pinned}
    }
    
    var unpinnedMemos: [Memo] {
        //        memos.filter { !$0.pinned}
        let sortedOldMemos = folder.memos.sorted()
        return sortedOldMemos.filter {!$0.pinned}
    }
    
    //    @State var memoSelected: Bool = false
    //    @ObservedObject var memos: [Memo]
    
    var memos: [Memo] {
        let sortedOldMemos = folder.memos.sorted()
        
        return sortedOldMemos
    }
    
    // need to be modified to have plus button when there's no memo
    var body: some View {
        
//        if memos.count != 0 {
            
            ZStack {
                if memos.count != 0 {
                LazyVGrid(columns: memoColumns) {
                    
                    
                    if pinnedMemos.count != 0 {
                        FilteredMemoList(memos: pinnedMemos, title: "pinned", parent: folder)
                    }

                    FilteredMemoList(memos: unpinnedMemos, title: "", parent: folder)
                    
                    
                }
                .environmentObject(selectedViewModel)
                // end of LazyVGrid
                //            .background(.blue)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        //                        if !memoSelected {
                        //                        if selectedMemos.count == 0 {
                        
                        if selectedViewModel.count == 0 {
                            // show plus button
                            Button(action: {
                                isAddingMemo = true
                                // navigate to MemoView
                            }) {
                                PlusImage()
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                            }
                        } else {
                            MemosToolBarView(pinnedAction: { selMemos in
                                // TODO : if all is pinned -> unpin
                                // else : pin all
                                
                                var allPinned = true
                                for each in selMemos {
                                    if each.pinned == false {
                                        allPinned = false
                                        break
                                    }
                                }
                                
                                if !allPinned {
                                    for each in selMemos {
                                        each.pinned = true
                                    }
                                }
                                context.saveCoreData()

                                
                            }, cutAction: { selMemos in
                                // TODO : .sheet(FolderMindMap)
                                // FullScreen: .sheet 대신, .fullScreenCover
                                // 쓰면 됨.
                                // https://www.hackingwithswift.com/quick-start/swiftui/how-to-present-a-full-screen-modal-view-using-fullscreencover
                                //
                                
                            }, copyAction: { selMemos in
                                // TODO : .sheet(FolderMindMap)
                                
                            }, changeColorAcion: {selMemos in
                                // Change backgroundColor
                                for eachMemo in selMemos {
//                                    eachMemo.bgColor = bgColor
                                }
                            }, removeAction: { selMemos in
                                for eachMemo in selMemos {
                                    selectedViewModel.memos.remove(eachMemo)
                                    Memo.delete(eachMemo)
                                }
                                context.saveCoreData()
                            }
                            )
                                .padding([.trailing], Sizes.largePadding)
                                .padding(.bottom,Sizes.overallPadding )
                        }
                    } // end of HStack
                } // end of VStack
                //                .background(.green)
            }
        }
    }
}

//struct MemoList_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoList(folder: deeperFolder)
//    }
//}
