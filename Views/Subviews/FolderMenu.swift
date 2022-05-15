//
//  FolderMenu.swift
//  DeeepMemo (iOS)
//
//  Created by 이한목 on 2022/05/15.
//


import SwiftUI

struct FolderMenu: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    @Binding var isAddingFolder: Bool
//    @State private var folderToNavigateTo: Folder? = nil
    @Binding var shouldNavigate: Bool
    @Binding var subfolderToNavigate: Folder? {
        didSet {
            self.shouldNavigate = true
        }
    }
    
    @State private var navigateTo = ""
       @State private var isActive = false
    
    var subFolders: [Folder]
    
    private func addMemo() {
        isAddingFolder = true
        print("add Memo Tapped!")
    }
    
    var body: some View {
        Menu {
            Button(LocalizedStringStorage.createFolder) { // TODO: Fix for foreigners
                addMemo()
            }
            Menu {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(subFolders, id: \.self) { subFolder in
//                        NavigationLink {
//                            FolderView(currentFolder: subFolder)
//                                .environmentObject(trashBinVM)
//
//                        } label: {
//                            Text(subFolder.title)
//                                .frame(alignment: .leading)
//                                .lineLimit(1)
//                                .foregroundColor(Color.blackAndWhite)
//                        }
//                        .onTapGesture(perform: {
//                            print("tapped!")
//                        })
//                        .simultaneousGesture(TapGesture().onEnded{
//                            memoEditVM.selectedMemos.removeAll()
//                            memoEditVM.initSelectedMemos()
//                            print("subFolder named \(subFolder.title) tapped!")
//                        })
                        Button {
                            print("button named \(subFolder.title) tapped")
                            self.subfolderToNavigate = subFolder
                        } label: {
                            Text(subFolder.title)
                        }

                    } // end of ForEach
                } // end of VStack
//                Button {
//                    print("test btn tapped")
//                } label: {
//                    Text("this is btn")
//                }

            } label: {
                Text(LocalizedStringStorage.moveToSubfolder) // TODO: Fix for foreigners
                    .foregroundColor(.black)
            }
//            .background(
//                NavigationLink(destination: Text(self.navigateTo), isActive: $isActive) {
//                    EmptyView()
//                })
        } label: {
            SystemImage("folder", size: 24)
                .tint(colorScheme == .dark ? .navColorForDark : .navColorForLight)
        }
    }
}
