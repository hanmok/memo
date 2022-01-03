//
//  HorCollapsibleMind.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/03.
//

import SwiftUI

struct HorCollapsibleMind: View, FolderNode {
    // navigation은, 밖에서 (으로) 전달해주어야 할 것 같은데 ??
    //
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    //    @State var content: () -> Content
    //    @State var content: Content
    //    var type: MindType
    //    var folder: Folder?
    var folder: Folder
    //    var project: Project?
    
    //    @State private var navigationSelected: Bool = false
    //    @Binding var shouldNavigate: Bool
    @State private var collapsed: Bool = true
    /// level of Depth
    /// Discussion: pass it using (varName + 1).
    
    private let collapsedLevel: Int = 0
    
    func moveToFolderView() {
        //        self.shouldNavigate.toggle()
        //        print("moveToFolderView has triggered \(self.shouldNavigate)")
    }
    func toggleCollapsed() {
        self.collapsed.toggle()
    }
    
    var subfolders: [Folder]? {
        folder.hasSubfolder ? folder.subFolders : nil
    }
    
    var numOfSubfolders: String{
        
        if folder.hasSubfolder{
            return "\(folder.subFolders!.count)"
        }
        
        return ""
    }
    
    var body: some View {
        //        NavigationView {
//        VStack(alignment: .leading) {
            HStack(alignment: .top) {
//                VStack(alignment: .leading) {
                    
                    // First Element in VStack.
                    // Collapsing Button and Title.
//                    HStack {
                        // Collapsing Button
                        Button(action: toggleCollapsed) {
                            if folder.hasSubfolder {
                                Image(systemName: collapsed ? "plus.circle" : "minus.circle")
                                    .setupAdditional(scheme: colorScheme)
                            } else {
                                Image(systemName: "")
                                    .setupAdditional(scheme: colorScheme)
                                
                            }
                        }
                        .padding(.leading, Sizes.overallPadding)
                        
                        // Title, Not working properly yet.
                        Button(action: moveToFolderView) {
                            Text(folder.title)
                                .adjustTintColor(scheme: colorScheme)
                            if numOfSubfolders != "" {
                                Text("(\(numOfSubfolders))")
                                    .adjustTintColor(scheme: colorScheme)
                            }
                        }
//                    }
                
                if subfolders != nil && !collapsed{
                        VStack(spacing: 0) {
                            ForEach(subfolders!) {subfolder in
                                
//                                CollapsibleMind(folder: subfolder)
                                HorCollapsibleMind(folder: subfolder)
                                    .padding(.bottom, 20)
                            }
                        }

                    .animation(.easeOut, value: collapsed)
                    .transition(.slide)
                } // end of second Element in VStack (HStack)
                Spacer()
            } // end of HStack
//            Spacer()
//        } // end of top VStack
        
    }
}


struct HorCollapsibleMind_Previews: PreviewProvider {
    static var previews: some View {
        HorCollapsibleMind(folder: deeperFolder)
    }
}
