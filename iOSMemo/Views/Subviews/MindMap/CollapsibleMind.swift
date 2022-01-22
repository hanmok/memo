//
//  CollapsibleMind.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/31.
//

import SwiftUI

enum MindType {
    case folder
    case project
}

protocol FolderNode {
    var folder: Folder { get }
}

//struct CollapsibleMind<Content: View>: View {
struct CollapsibleMind: View, FolderNode {
// navigation은, 밖에서 (으로) 전달해주어야 할 것 같은데 ??
//
    @Environment(\.colorScheme) var colorScheme: ColorScheme

//    @State var content: () -> Content
//    @State var content: Content
//    var type: MindType
//    var folder: Folder?
    var folder: Folder
//    var project: Project?

    var subfolders: [Folder] {
        var folders: [Folder] = []
        for eachFolder in folder.subfolders {
            folders.append(eachFolder)
        }
        return folders
    }
    
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

//    var subfolders: [Folder]? {
//        folder.subfolders ? folder.subfolders : nil
//    }
    

    var numOfSubfolders: String{

        if folder.subfolders.count != 0 {
            return "\(folder.subfolders.count)"
        }

        return ""
    }

    var body: some View {
//        NavigationView {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {

                // First Element in VStack
                HStack {
                    // add Indentation to the left to indicate depth for both folder and project
                    ForEach((0 ..< collapsedLevel), id: \.self) {_ in
                        Text("\t")
                    }
                    // Collapsing Button
                    Button(action: toggleCollapsed) {
                        if folder.subfolders.count != 0 {
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
                }
//                .padding(.bottom, Sizes.minimalSpacing)

                // Second Element in VStack
//                if subfolders != nil && !collapsed{
                if folder.subfolders.count != 0 && !collapsed{
                HStack {
                    ForEach((0 ..< collapsedLevel + 1), id: \.self) {_ in
                        Text("\t")
                    }

                    VStack(spacing: 0) {
//                        if subfolders != nil && !collapsed{
                        ForEach(subfolders) {subfolder in

                                CollapsibleMind(folder: subfolder)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                    .animation(.easeOut, value: collapsed)
                    .transition(.slide)
                } // end of second Element in VStack (HStack)
//                Spacer()
            } // end of VStack
            .background(.yellow)
            Spacer()

        } // end of HStack
        .onAppear {
            print("this view has appeared")
        }
    }
}

//struct CollapsibleMind_Previews: PreviewProvider {
//    static var previews: some View {
//        CollapsibleMind( folder: deeperFolder)
//    }
//}


//struct Project {
//    var title: String
//    var id: UUID
//}

// 문제는 ?? rendering 할때, ... 음 .. 전체를 다 하는 것 같아
// 하나만 해야하는데 그게 아닌거지 ...
// 그럼.. 어떻게 해야하지 ? 확인은 어떻게 하지? 성능을 어떻게 향상시키지??
// 하나만 열 때에는 충분히 빠른 속도라서, 이 속도가 다른 것들에 적용되면 좋을 것 같아 .















////
////  CollapsibleMind.swift
////  DeeepMemo
////
////  Created by Mac mini on 2021/12/31.
////
//
//import SwiftUI
//
//enum MindType {
//    case folder
//    case project
//}
//
//protocol FolderNode {
//    var folder: Folder { get }
//}
//
////struct CollapsibleMind<Content: View>: View {
//struct CollapsibleMind: View, FolderNode {
//// navigation은, 밖에서 (으로) 전달해주어야 할 것 같은데 ??
////
//    @Environment(\.colorScheme) var colorScheme: ColorScheme
//
////    @State var content: () -> Content
////    @State var content: Content
////    var type: MindType
////    var folder: Folder?
//    var folder: Folder
////    var project: Project?
//
////    @State private var navigationSelected: Bool = false
////    @Binding var shouldNavigate: Bool
//    @State private var collapsed: Bool = true
//    /// level of Depth
//    /// Discussion: pass it using (varName + 1).
//
//    private let collapsedLevel: Int = 0
//
//    func moveToFolderView() {
////        self.shouldNavigate.toggle()
////        print("moveToFolderView has triggered \(self.shouldNavigate)")
//    }
//    func toggleCollapsed() {
//        self.collapsed.toggle()
//    }
//
//    var subfolders: [Folder]? {
//        folder.hasSubfolder ? folder.subFolders : nil
//    }
//
//    var numOfSubfolders: String{
//
//        if folder.hasSubfolder{
//            return "\(folder.subFolders!.count)"
//        }
//
//        return ""
//    }
//
//    var body: some View {
////        NavigationView {
//        HStack(alignment: .top) {
//            VStack(alignment: .leading) {
////                NavigationView {
////                NavigationLink(
////                  destination: FolderView(folder: folder),
////                  // 1
////                  isActive: $shouldNavigate
////                  // 2
////                ) { }
////                }
//
//                HStack {
//                    // add Indentation to the left to indicate depth for both folder and project
//                    ForEach((0 ..< collapsedLevel), id: \.self) {_ in
//                        Text("\t")
//                    }
//                    // Collapsing Button
//                    Button(action: toggleCollapsed) {
//                        if folder.hasSubfolder {
//                        Image(systemName: collapsed ?  "plus.circle" : "minus.circle")
//                            .setupAdditional(scheme: colorScheme)
//                        } else {
//                            Image(systemName: "")
//                                .setupAdditional(scheme: colorScheme)
//
//                        }
//                    }.padding(.leading, Sizes.overallPadding)
//
//                    // Title
//                    Button(action: moveToFolderView) {
//                        Text(folder.title)
//                        if numOfSubfolders != "" {
//                            Text("   (\(numOfSubfolders))")
//                        }
//                    }
//
//                }
//                .padding(.bottom, Sizes.minimalSpacing)
//
//                HStack {
//                    ForEach((0 ..< collapsedLevel + 1), id: \.self) {_ in
//                        Text("\t")
//                    }
//
//                    VStack(spacing: 0) {
//                        if subfolders != nil && !collapsed{
//                            ForEach(subfolders!) {subfolder in
//
//                                CollapsibleMind(folder: subfolder)
//                            }
//                        }
//                    }
////                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .infinity)
//                    .animation(.easeOut, value: collapsed)
//                    .transition(.slide)
//                }
//            }
////            .frame(maxHeight: .infinity)
//            .background(.yellow)
//            Spacer()
//        } // end of HStack
//
//        .onAppear {
//            print("this view has appeared")
//        }
//    }
//
//}
//
//struct CollapsibleMind_Previews: PreviewProvider {
//    static var previews: some View {
////        CollapsibleMind(content: {
////            EmptyView()
////        }, type: .folder)
////        CollapsibleMind(type: .folder, folder: deeperFolder)
//        CollapsibleMind( folder: deeperFolder)
////        CollapsibleMind(content: EmptyView())
//    }
//}
//
//
//struct Project {
//    var title: String
//    var id: UUID
//}
//
//// 문제는 ?? rendering 할때, ... 음 .. 전체를 다 하는 것 같아
//// 하나만 해야하는데 그게 아닌거지 ...
//// 그럼.. 어떻게 해야하지 ? 확인은 어떻게 하지? 성능을 어떻게 향상시키지??
//// 하나만 열 때에는 충분히 빠른 속도라서, 이 속도가 다른 것들에 적용되면 좋을 것 같아 .
