





import SwiftUI

struct VerCollapsibleFolder: View, FolderNode {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var expansion: ExpandingClass
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoEditVM: MemoEditViewModel
//    @StateObject var memoEditVM = MemoEditViewModel()
    
    let siblingSpacing: CGFloat = 3
    let parentSpacing: CGFloat = 3
    let basicSpacing: CGFloat = 2
    
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
    
    @State private var collapsed: Bool = true
    
    private let depthLevel: Int = 0
    
    var numOfSubfolders: String{
        
        if folder.subfolders.count != 0 {
            return "\(folder.subfolders.count)"
        }
        return ""
    }
    
    
    var body: some View {

        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                
                // First Element in VStack,collapsingButton + self.title
                HStack {
                    // Collapsing Button
                    
                    if folder.subfolders.isEmpty {
                        
                        Image("")
                            .frame(width: 12, height: 12)
                    } else {
                        Button(action: toggleCollapsed) {
                            ChangeableImage(imageSystemName: shouldExpandOverall ? "chevron.down" : "chevron.right", width: 12, height: 12)
                        }
                    }
                    
                    NavigationLink(destination:
                                    FolderView( currentFolder: folder)
                                    .environmentObject(memoEditVM)
                                    .environmentObject(folderEditVM)
                    ) {
                        Text(folder.title)
                    }
                }
                
                // Second Element in VStack, children of self folder
                if folder.subfolders.count != 0 {
                    HStack {
                        ForEach((0 ..< depthLevel + 1), id: \.self) { _ in
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
//                                            .environmentObject(showingMemoVM)
                                            .padding(.bottom, siblingSpacing)
                                    }
                                }// this is .. super heavy ??
                            }
                        }
                    }
                } // end of second Element in VStack (HStack)
            } // end of VStack
            Spacer()
        } // end of HStack
        .padding(basicSpacing)
        .tint(colorScheme == .dark ? .white : .black)
        .onAppear {
            if expansion.shouldExpand {
                collapsed = false
            }
        }
    }
}
