//
//  HorCollapsibleMind.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/03.
//

import SwiftUI
import CoreData

// do i need a closure here ?

struct HorCollapsibleMind: View, FolderNode {
    // navigation은, 밖에서 (으로) 전달해주어야 할 것 같은데 ??
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var folderVM: FolderViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var expansion: ExpandingClass
    var folder: Folder
    
    var openFolder: (Folder) -> Void = { _ in }
    
    
    @State private var collapsed: Bool = true
    /// level of Depth
    
    private let collapsedLevel: Int = 0
    
    var subfolders: [Folder] {
        var folders: [Folder] = []
        for eachFolder in folder.subfolders {
            folders.append(eachFolder)
        }
        return folders
    }
    
    var shouldExpandOverall: Bool {
        return !collapsed || expansion.shouldExpand
    }
    
    func moveToFolderView() {
    }
    
    func toggleCollapsed() {
        self.collapsed.toggle()
        if self.expansion.shouldExpand {
            self.expansion.shouldExpand = false
        }
    }
    
    var numOfSubfolders: String{
        
        if folder.subfolders.count != 0{
            return "\(folder.subfolders.count)"
        }
        return ""
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Button(action: toggleCollapsed) {
                
                HStack {
                    if folder.subfolders.count != 0 {
                        Image(systemName: !shouldExpandOverall ? "plus.circle" : "minus.circle")
                    } else {
                        Image(systemName: "")
                    }
                    
                    Text(folder.title)
                    
                } // end of HStack
                .adjustTintColor(scheme: colorScheme)
                
            } // end of Button
            .padding(.leading, Sizes.overallPadding)
            .contextMenu {
                VStack {
                    Button(action: {
                        folderVM.navigationTargetFolder = folder
//                         dismiss
//                        navigationLink
                    }) {
                        HStack {
                            Text("open")
                        }
                    }
                    Button(action: {
                        //TODO : present TextField
                    }) {
                        Text("rename")
                    }
                    Button(action: {
                        Folder.delete(folder)
                        context.saveCoreData()
                    }) {
                        Text("remove")
                    }
                    Button(action: {
                        folderVM.copiedFolders.append(folder)
                    }) {
                        Text("copy")
                    }
                    Button(action: {
                        folderVM.cuttedFolders.append(folder)
                    }) {
                        Text("cut")
                    }
                    Button(action: {
                        for each in folderVM.savedFolders {
                            folder.add(subfolder: each)
                        }
                        context.saveCoreData()
                        //relocate !
                        folderVM.cuttedFolders = []
                        
                        folderVM.copiedFolders = []
                        
                    }) {
                        Text("paste here")
                    }
                }
            }
            
            
            if folder.subfolders.count != 0 && shouldExpandOverall {
                VStack(spacing: 0) {
                    ForEach(subfolders) {subfolder in
                        
                        HorCollapsibleMind(expansion: expansion, folder: subfolder)
                        
                            .padding(.bottom, 10)
                    }
                }
                .animation(.easeOut, value: shouldExpandOverall)
                .transition(.slide)
            } // end of second Element in VStack (HStack)
            
            Spacer()
        }
        .onAppear {
            if expansion.shouldExpand {
                collapsed = false
            }
        }
    }
}


//struct HorCollapsibleMind_Previews: PreviewProvider {
//    static var previews: some View {
//        HorCollapsibleMind(folder: deeperFolder)
//    }
//}
