//
//  SubFolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/27.
//

import SwiftUI
import CoreData
struct SubFolderView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var folder: Folder
    
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @Binding var isShowingSubFolderView: Bool
    @Binding var isAddingFolder: Bool
    
    var body: some View {
        
        let subFolders = Folder.getSortedSubFolders(folder: folder)
        
        return VStack(alignment: .leading) {
            
            // Back Button and Adding SubFolder Button
            
            HStack {
                Button {
                    // dismiss
                    isShowingSubFolderView = false
                } label: {
                    SystemImage("arrow.right")
                        .foregroundColor(Color.blackAndWhite)
                }
                .padding(.leading, 12)
                
                Spacer()
                
                Button {
                    isAddingFolder = true
                } label: {
                    SystemImage("folder.badge.plus", size: 28)
                        .foregroundColor(Color.blackAndWhite)
                    
                }
                .padding(.trailing, 12)
            }
            .padding(.vertical, Sizes.smallSpacing)
            
            
            
            VStack(alignment: .leading, spacing: 5) {
                
                ForEach(subFolders) { subFolder in
                    
                    NavigationLink {
                        FolderView(currentFolder: subFolder)
                            .environmentObject(folderEditVM)
                            .environmentObject(memoEditVM)
                            .environmentObject(memoOrder)
                            .environmentObject(trashBinVM)
                    } label: {
                        Text(subFolder.title)
                            .frame(alignment: .leading)
                            .lineLimit(1)
                            .foregroundColor(Color.blackAndWhite)
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
            .padding(.bottom, subFolders.count == 0 ? 0 : 10)
            
            if subFolders.count == 0 {
                
                Button {
                    isAddingFolder = true
                } label: {
                    Text("Press to Add")
                        .adjustTintColor(scheme: colorScheme)
                }
                .padding(.leading, 12)
                .padding(.bottom, 10)
            }
        }
        .frame(width: UIScreen.screenWidth / 2.5)
        .background(Color.memoBoxColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(colorScheme == .dark ? Color.subColor : Color.init(white: 0.85) ,lineWidth: 1)
        )
    }
}

