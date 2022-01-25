//import SwiftUI
//
//// openFolder ?
//struct VerCollapsibleFolderNode: View, FolderNode {
//
//    //    @Environment(\.presentationMode) var presentationMode
//
//    @Environment(\.colorScheme) var colorScheme: ColorScheme
////    @EnvironmentObject var showingMemoVM: ShowingMemoFolderVM
//
//    @ObservedObject var expansion: ExpandingClass
//
////    let siblingSpacing: CGFloat = 5
////    let parentSpacing: CGFloat = 5
////    let basicSpacing: CGFloat = 3
//
//    let siblingSpacing: CGFloat = 3
//    let parentSpacing: CGFloat = 3
//    let basicSpacing: CGFloat = 2
//
//    var folder: Folder
//
//    var subfolders: [Folder] {
//        var folders: [Folder] = []
//        for eachFolder in folder.subfolders.sorted() {
//            folders.append(eachFolder)
//        }
//        return folders
//    }
//
//    var shouldExpandOverall: Bool {
//        return !collapsed || expansion.shouldExpand
//    }
//
//    func toggleCollapsed() {
//        self.collapsed.toggle()
//        if self.expansion.shouldExpand {
//            self.expansion.shouldExpand = false
//        }
//    }
//
//    @State private var collapsed: Bool = true
//
//    private let collapsedLevel: Int = 0
//
//    var numOfSubfolders: String{
//
//        if folder.subfolders.count != 0 {
//            return "\(folder.subfolders.count)"
//        }
//        return ""
//    }
//
//
//    var body: some View {
//        //        NavigationView {
//        HStack(alignment: .top) {
//            VStack(alignment: .leading) {
//
//                // First Element in VStack, self.title
//                HStack {
//                    // Collapsing Button
//
//                    if folder.subfolders.isEmpty {
//
//                        Image("")
//                            .frame(width: 12, height: 12)
//                    } else {
//                        Button(action: toggleCollapsed) {
//                            ChangeableImage(imageSystemName: shouldExpandOverall ? "chevron.down" : "chevron.right", width: 12, height: 12)
////                            Image(systemName: shouldExpandOverall ? "chevron.down" : "chevron.right")
////                                .resizable()
////                                .frame(width: 12, height: 12)
////                                .frame(width: 5, height: 5)
////                                .background(.green)
//
//                        }
//                    }
//
//
////                    HStack(alignment: .bottom) {
//                        Text(folder.title)
////                        .background(.yellow)
////                        + Text(" \(numOfSubfolders) ").font(.caption)
////                    }
//
//                    if !folder.memos.isEmpty {
//                        Button(action: {
//                            showingMemoVM.folderToShow = folder
//                        }) {
//                            Text(Image(systemName: "archivebox"))
//                        }
//                    }
//                }
//
//                // Second Element in VStack, children of self folder
//                if folder.subfolders.count != 0 {
//                    HStack {
//                        ForEach((0 ..< collapsedLevel + 1), id: \.self) { _ in
//                            Text("   ")
//                        }
//                        if folder.subfolders.count != 0 && shouldExpandOverall {
//                            VStack(spacing: 0) {
//                                ForEach(subfolders) {subfolder in
//                                    // if last subfolder, no padding to the bottom
//                                    if subfolder == subfolders.last {
//                                        VerCollapsibleFolderNode(expansion: expansion, folder: subfolder)
//                                    } else {
//                                        VerCollapsibleFolderNode(expansion: expansion, folder: subfolder)
//                                            .environmentObject(showingMemoVM)
//                                            .padding(.bottom, siblingSpacing)
//                                    }
//                                }// this is .. super heavy ??
//                            }
//                        }
//                    }
//                } // end of second Element in VStack (HStack)
//            } // end of VStack
//            Spacer()
//        } // end of HStack
//        .padding(basicSpacing)
//        .tint(colorScheme == .dark ? .white : .black)
//        .onAppear {
//            if expansion.shouldExpand {
//                collapsed = false
//            }
//        }
//    }
//}
