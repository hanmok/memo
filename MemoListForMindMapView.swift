//
//  FilteredMemoList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/18.
//

import SwiftUI

struct MemoListForMindMapView: View {
    
    //    @Binding var showMemoList: Bool
    
    var folder: Folder
    var title: String {
        folder.title
    }
    
    @Binding var showMemo: Bool
    
    var pinnedMemos: [Memo] {
        folder.memos.filter { $0.pinned == true }.sorted()
    }
    
    var unpinnedMemos: [Memo] {
        folder.memos.filter { $0.pinned == false }.sorted()
    }
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var showingMemoVM: ShowingMemoFolderVM
    
    var body: some View {
            HStack {
                Text(folder.title)
                    .font(.title3)
                    .padding(.leading, Sizes.overallPadding)
                Spacer()
            }
            .padding(.bottom, 15)
        
        if !pinnedMemos.isEmpty {
        // pinned List
        Section {
            ForEach(pinnedMemos, id: \.self) { memo in
                Button {
                    showingMemoVM.selectedMemo = memo
                    showMemo = true
                } label: {
                    MemoBoxView(memo: memo)
                        .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                }
            }
        } header: {
            VStack {
                HStack {
                    ChangeableImage(imageSystemName: "pin.fill", width: 16, height: 16)
                        .frame(alignment: .topLeading)
                        .rotationEffect(.degrees(45))
                        .padding(.leading, Sizes.overallPadding + 4)
                    Spacer()
                }
            }
        }
            
        Rectangle()
            .frame(height: 1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(Color(.sRGB, white: 0.85, opacity: 0.5))
            
            }
        
        Section {
            ForEach(unpinnedMemos, id: \.self) { memo in
                Button {
                    showingMemoVM.selectedMemo = memo
                    showMemo = true
                } label: {
                    MemoBoxView(memo: memo)
                        .frame(width: UIScreen.screenWidth - 20, alignment: .center)
                }
            }
        }
        .onDisappear {
            showingMemoVM.folderToShow = nil
        }
    }
    
}

//struct FilteredMemoList_Previews: PreviewProvider {
//    static var previews: some View {
//        FilteredMemoList()
//    }
//}
