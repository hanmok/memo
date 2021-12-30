//
//  CollapsibleFolderList.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/30.
//

import SwiftUI

struct CollapsibleFolderList: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
//    @AppStorage("hasCollapsed") var hasCollapsed: Bool
    @AppStorage("hasCollapsed") var hasCollapsed = false
    
//    init(hasCollapsed: Bool, folder: Folder) {
//        self.hasCollapsed = hasCollapsed
//        self.folder = folder
//    }
    
    var folder: Folder
    var subfolders: [Folder] {
        return folder.subFolders!
    }
    // 30 : folder height.
    var subfoldersHeight: CGFloat {
        if folder.subFolders != nil {
            return CGFloat(folder.subFolders!.count * 30)
        } else { return 0 }
    }
    
    var firstFolderName: String {
        if folder.subFolders != nil {
            return folder.subFolders!.first!.title
        } else {
            return "there's no any subfolder in current folder"
        }
    }
    // 접는걸 어떻게 처리할거야 ? none or all ?  이거.. 다르게 처리할 수 있으면 좋겠는데..
    // 그걸 어떻게 select 하지 ? 
    
    //    var content:
    @State private var collapsed: Bool = true
    
    func navigateToFirstFolder() {
        if folder.subFolders != nil {
            // navigate
        }
//        else {
//    //         do nothing
//        }
    }
    
    var body: some View {
        //        GeometryReader { myproxy in
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                
                
//                Button(
//                    action: { self.collapsed.toggle() },
//                    label: {
//                        HStack {
////                            Text("Tap to open all the subfolders")
//                            Text(firstFolderName)
//                            Spacer()
//                                .frame(height: 20)
//                            Image(systemName: self.collapsed ? "chevron.down" : "chevron.up")
//                        }
//                        .background(Color.white.opacity(0.01))
//                    }
//                )
//                    .buttonStyle(PlainButtonStyle())
                
                HStack {
//                    Button(action: navigateToFirstFolder) {
//                        Text(firstFolderName)
//                    }
                    Spacer()
                    Button(
                        action: { self.collapsed.toggle() },
                        label: {
                                ChangeableImage(colorScheme: _colorScheme, imageSystemName: self.collapsed ? "chevron.down" : "chevron.up", width: 20, height: 20)
                        }
                    )
                        .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, Sizes.overallPadding)
                
                
                
                
                ScrollView {
                    LazyVStack {
                        ForEach(subfolders) { subfolder in
                            NavigationLink(destination: FolderView(folder: subfolder, hasCollapsed: self.collapsed)) {
                                Text(subfolder.title)
                                    .tint(.primary)
//                                    .background(.red)
                                Spacer()
                                ChangeableImage(colorScheme: _colorScheme, imageSystemName: "chevron.right", width: 10, height: 10)
                            }
//                            .padding(.vertical, 5)
                            .padding(.top, 10)
                            .padding(.horizontal, Sizes.overallPadding)
                            .frame(maxWidth: .infinity, idealHeight: 20, alignment: .leading)
                        }
                    }
                }
                
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : subfoldersHeight)

                    .background(.yellow)
                    .cornerRadius(10)
                    .padding(.horizontal, Sizes.overallPadding)
                                    .clipped()
                    .animation(.easeInOut, value: collapsed)
                    .transition(.slide)
                
                SubFolderToolBarView()
                    .opacity(0.8)
                    .cornerRadius(10)
                    .padding(.horizontal, Sizes.overallPadding)
                
                MemoList(folder: folder)
                    .padding(.horizontal, Sizes.overallPadding)
                Spacer()
            }
            .background(.green)
            //    }
        }
    }
}

struct CollapsibleFolderList_Previews: PreviewProvider {
    static var previews: some View {
        CollapsibleFolderList(hasCollapsed: false, folder: deeperFolder)
    }
}
