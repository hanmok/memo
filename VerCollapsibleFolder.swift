import SwiftUI

// openFolder ?
struct VerCollapsibleFolder: View, FolderNode {
    
    //    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var showingMemoVM: ShowingMemoFolderVM
    
    @ObservedObject var expansion: ExpandingClass
    
    let siblingSpacing: CGFloat = 5
    let parentSpacing: CGFloat = 5
    let basicSpacing: CGFloat = 3
    
    var folder: Folder
    
    var subfolders: [Folder] {
        var folders: [Folder] = []
        for eachFolder in folder.subfolders.sorted() {
            folders.append(eachFolder)
        }
        return folders
    }
    
    var shouldExpandOverall: Bool {
        return !collapsed || expansion.shouldExpand
    }
    
    func toggleCollapsed() {
        self.collapsed.toggle()
        if self.expansion.shouldExpand {
            self.expansion.shouldExpand = false
        }
    }
    
    //    @State private var navigationSelected: Bool = false
    //    @Binding var shouldNavigate: Bool
    @State private var collapsed: Bool = true
    //    @State private var collapsed: Bool = false
    /// level of Depth
    /// Discussion: pass it using (varName + 1).
    
    private let collapsedLevel: Int = 0
    
    func moveToFolderView() {
        
    }
    
    func openMemoBox() {
        
    }
    
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
                    
                    // Collapsing Button
                    Button(action: toggleCollapsed) {
                        HStack(alignment: .bottom) {
                            Text(folder.title)
                            + Text(" \(numOfSubfolders) ").font(.caption)
                        }
                    }
                    
                    if !folder.memos.isEmpty {
                        Button(action: {
                            showingMemoVM.folderToShow = folder
                        }) {
                            Text(Image(systemName: "archivebox"))
                        }
                    }
                    //                    .padding(.leading, Sizes.overallPadding)
                }
                
                if folder.subfolders.count != 0 {
                    HStack {
                        ForEach((0 ..< collapsedLevel + 1), id: \.self) { _ in
                            Text("   ")
                        }
                        if folder.subfolders.count != 0 && shouldExpandOverall {
                            VStack(spacing: 0) {
                                ForEach(subfolders) {subfolder in
                                    // if last subfolder, no padding to the bottom
                                    if subfolder == subfolders.last {
                                        VerCollapsibleFolder(expansion: expansion, folder: subfolder)
                                    } else {
                                        VerCollapsibleFolder(expansion: expansion, folder: subfolder)
                                            .environmentObject(showingMemoVM)
                                            .padding(.bottom, siblingSpacing)
                                    }
                                }
                            }
                        }
                    }
//                    .animation(.easeOut, value: collapsed)
//                    .animation(.easeOut, value: shouldExpandOverall)
//                    .transition(.slide)
                    
                } // end of second Element in VStack (HStack)
            } // end of VStack
            Spacer()
        } // end of HStack
        .padding(basicSpacing)
        .tint(colorScheme == .dark ? .white : .black)
        .onAppear {
            print("this view has appeared")
            if expansion.shouldExpand {
                collapsed = false
            }
        }
    }
}
