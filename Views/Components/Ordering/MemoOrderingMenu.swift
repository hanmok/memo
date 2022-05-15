//
//  MemoOrderingMenu.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI

struct FolderMenu: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @Binding var isAddingFolder: Bool
    
    var subFolders: [Folder]
    
    private func addMemo() {
        isAddingFolder = true
    }
    
    var body: some View {
        Menu {
            Button("폴더 생성") {
                addMemo()
            }
            Menu {
                VStack(alignment: .leading, spacing: 5) {
//                    List {
                    ForEach(subFolders, id: \.self) { subFolder in
                        NavigationLink {
                            FolderView(currentFolder: subFolder)
                                .environmentObject(trashBinVM)
                        } label: {
                            Text(subFolder.title)
                                .frame(alignment: .leading)
                                .lineLimit(1)
                                .foregroundColor(Color.blackAndWhite)
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            memoEditVM.selectedMemos.removeAll()
                            memoEditVM.initSelectedMemos()
                        })
                    } // end of ForEach
//                    }
                } // end of VStack
            } label: {
                Text("폴더 이동") // TODO: Fix for foreigners
                    .foregroundColor(.black)
            }
        } label: {
            SystemImage("folder", size: 24)
//                .tint(Color.navBtnColor)
                .tint(colorScheme == .dark ? .newNavForDark : .newNavForLight)
        }
    }
}


struct MemoOrderingMenu: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var parentFolder: Folder
    
    var body: some View {
        Menu {
            Text(LocalizedStringStorage.memoOrdering)
            MemoOrderingButton(parentFolder: parentFolder, type: .modificationDate)
            MemoOrderingButton(parentFolder: parentFolder, type: .creationDate)
            MemoOrderingButton(parentFolder: parentFolder, type: .alphabetical)
            
            Divider()
            
            MemoAscDecButton(parentFolder: parentFolder, isAscending: true)
            MemoAscDecButton(parentFolder: parentFolder, isAscending: false)
            
        } label: {
            SystemImage( "arrow.up.arrow.down")
//                .tint(Color.navBtnColor)
                .tint(colorScheme == .dark ? .newNavForDark : .newNavForLight)
        }
    }
}


struct MemoOrderingMenuInSecondView: View {

    var body: some View {
        Menu {
            
            MemoOrderingButton2( type: .modificationDate)
            MemoOrderingButton2( type: .creationDate)
            MemoOrderingButton2( type: .alphabetical)
            
            Divider()
            
            MemoAscDecButton2(isAscending: true)
            MemoAscDecButton2(isAscending: false)
            
        } label: {
            Text(LocalizedStringStorage.memoOrdering)
        }
    }
}
