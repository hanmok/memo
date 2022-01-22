//
//  SUbFolderPageView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/07.
//

import SwiftUI

struct SubFolderPageView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    //    @ObservedObject var folder: Folder
    @EnvironmentObject var currentFolder: Folder
//    @Binding var shouldAddSubFolder: Bool
    @Binding var shouldHideSubFolderView: Bool
    
    var subfolders: [Folder] {
        let sortedOldFolders = currentFolder.subfolders.sorted()
        
        return sortedOldFolders
    }
    
    func makeNewSubfolder() {
//        shouldAddSubFolder = true
        folderEditVM.shouldAddFolder = true
    }
    
    var body: some View {
        // MARK: - SubFolder List
        VStack {
            HStack {
                Spacer()
                SubFoldersToolView( shouldHideSubFolderView: $shouldHideSubFolderView)
            }
//            if !folderEditVM.shouldHideSubFolders {
            if !shouldHideSubFolderView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if subfolders.count != 0 {
                            ForEach(subfolders) { subfolder in

                                NavigationLink(
                                    destination: FolderView(currentFolder: subfolder)
                                        .environmentObject(folderEditVM)
                                        .environmentObject(memoEditVM)
                                )
                                {
                                        FolderLabelView(folder: subfolder)
                                    }
                                    .padding(.horizontal, Sizes.overallPadding)
                                    .padding(.top, Sizes.minimalSpacing * 2)
                            } // end of ForEach.
                        } else { // subfolder.count == 0
                            //                            HStack(alignment: .center, spacing: 3) {
                            HStack(spacing: 3) {
                                Button(action: makeNewSubfolder) {
                                    Text("Press ") + Text(Image(systemName: "folder.badge.plus")) + Text(" to make a new subfolder")
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title3)
                            .tint(colorScheme == .dark ? .white : .black)
                            .padding(.horizontal, Sizes.overallPadding)
                            .padding(.top, Sizes.minimalSpacing * 4)
                            //                            .background(.green)
                        }
                        
                    }
                    .padding(.bottom, 20)
                    .background(Color(.sRGB, white: 0.8, opacity: 0.5))
                    //                }
                } // end of horizontal ScrollView
            }
            //            }
        }
    }
}


//struct SubFolderPageView2_Previews: PreviewProvider {
//
//    static var testFolder = Folder(title: "test Folder", context: PersistenceController.preview.container.viewContext)
//
//    static var previews: some View {
//        //        SubFolderPageView(folder: testFolder)
//        SubFolderPageView3( shouldAddSubFolder: .constant(false), shouldHideSubFolderView: .constant(true))
//            .environmentObject(testFolder)
//    }
//}

