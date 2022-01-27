//
//  SubFolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/27.
//

import SwiftUI

struct SubFolderView: View {
    
    //    @EnvironmentObject var folder: Folder
    @ObservedObject var folder: Folder
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @Binding var isShowingSubFolderView: Bool
    
    var body: some View {
        let subFolders = folder.subfolders.sorted()
        
        return VStack {
            HStack {
                Button {
                    // dismiss
                    isShowingSubFolderView = false
                } label: {
                    ChangeableImage(imageSystemName: "arrow.right")
                }
                .padding(.leading, Sizes.smallSpacing)
                
                Spacer()
                
                Button {
                    // add new folder
                    folderEditVM.shouldAddFolder = true
                } label: {
                    ChangeableImage(imageSystemName: "folder.badge.plus")
                }
                .padding(.trailing, Sizes.smallSpacing)
            }
            .padding(.vertical, Sizes.smallSpacing)
            
            VStack {
                ForEach(subFolders) { subFolder in
                    NavigationLink {
                        FolderView(currentFolder: subFolder)
                            .environmentObject(folderEditVM)
                            .environmentObject(memoEditVM)
                    } label: {
                        Text(subFolder.title)
                    }
                }
            }
            
            if subFolders.count == 0 {
               
                Button {
                    folderEditVM.shouldAddFolder = true
                } label: {
                    Text("Press to Add")
                }

            }
            
            Spacer()
        }
    }
}

//struct SubFolderView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubFolderView()
//    }
//}
