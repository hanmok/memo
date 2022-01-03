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
    @ObservedObject var expansion: ExpandingClass
    var folder: Folder
    
    @State private var collapsed: Bool = true
    /// level of Depth
    
    private let collapsedLevel: Int = 0
    
    
    var shouldExpandOverall: Bool {
        return !collapsed || expansion.shouldExpand
    }
    
    func moveToFolderView() {
        //        self.shouldNavigate.toggle()
        //        print("moveToFolderView has triggered \(self.shouldNavigate)")
    }
    func toggleCollapsed() {
        self.collapsed.toggle()
        if self.expansion.shouldExpand {
            self.expansion.shouldExpand = false
        }
        
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
            
            Button(action: toggleCollapsed) {
                if folder.hasSubfolder {
                    Image(systemName: !shouldExpandOverall ? "plus.circle" : "minus.circle")
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
            
//            if subfolders != nil && !collapsed{
            if subfolders != nil && shouldExpandOverall{
                VStack(spacing: 0) {
                    ForEach(subfolders!) {subfolder in
                        
                        //                                CollapsibleMind(folder: subfolder)
//                        HorCollapsibleMind(expansion: expansion, folder: subfolder)
//                        HorCollapsibleMind(folder: subfolder, expansion: expansion)
                        HorCollapsibleMind(expansion: expansion, folder: subfolder)
                            
                            .padding(.bottom, 20)
                    }
                }
//                .animation(.easeOut, value: collapsed)
                .animation(.easeOut, value: shouldExpandOverall)
                .transition(.slide)
            } // end of second Element in VStack (HStack)
            Spacer()
        }
        .onAppear {
            if expansion.shouldExpand {
                collapsed = false
            }
            print("collapsed: \(collapsed)")
            print("expand: \(expansion.shouldExpand)")
            print("shouldExpandOverall : \(shouldExpandOverall)")
            
        }
        .onDisappear {
            print("collapsed: \(collapsed)")
            print("expand: \(expansion.shouldExpand)")
            print("shouldExpandOverall : \(shouldExpandOverall)")
        }
        // end of HStack
        //            Spacer()
        //        } // end of top VStack
        
    }
}


//struct HorCollapsibleMind_Previews: PreviewProvider {
//    static var previews: some View {
//        HorCollapsibleMind(folder: deeperFolder)
//    }
//}
