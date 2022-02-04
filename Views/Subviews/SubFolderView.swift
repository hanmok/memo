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
    @Binding var isAddingFolder: Bool
    
    var body: some View {
        let subFolders = folder.subfolders.sorted()
        
        return VStack(alignment: .leading) {
            
            // Back Button and Adding SubFolder Button
            
            HStack {
                Button {
                    // dismiss
                    isShowingSubFolderView = false
                } label: {
                    ChangeableImage(imageSystemName: "arrow.right")
                }
                .padding(.leading, 12)
                
                Spacer()
                
                Button {
                    isAddingFolder = true
                } label: {
                    ChangeableImage(imageSystemName: "folder.badge.plus", width: 28, height: 28)
                }
                .padding(.trailing, 12)
            }
            .padding(.vertical, Sizes.smallSpacing)
            
            
            
            VStack(alignment: .leading, spacing: 5) {
                ForEach(subFolders) { subFolder in
                    // how to make.. it disappear if moved ?
                    NavigationLink {
                        FolderView(currentFolder: subFolder)
                            .environmentObject(folderEditVM)
                            .environmentObject(memoEditVM)
                    } label: {
                        Text(subFolder.title)
                            .frame(alignment: .leading)
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        // hide SubFolderView when navigate
                        isShowingSubFolderView = false
                        memoEditVM.selectedMemos.removeAll()
                        memoEditVM.initSelectedMemos()
                    })

                } // end of ForEach
            } // end of VStack
            .padding(.leading, 12)
            
            if subFolders.count == 0 {
               
                Button {
                    isAddingFolder = true
                } label: {
                    Text("Press to Add")
                }
                .padding(.leading, 12)
            }
            Spacer()
        }
        .frame(width: UIScreen.screenWidth / 2.5)
            .background(Color.subColor)
            .cornerRadius(10)
        
    }
}

//struct SubFolderView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubFolderView()
//    }
//}
