import SwiftUI

//enum MindType {
//    case folder
//    case project
//}
//
//protocol FolderNode {
//    var folder: Folder { get }
//}

//struct CollapsibleMind<Content: View>: View {
struct VerCollapsibleFolder: View, FolderNode {
    
//    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var showingMemoVM: ShowingMemoFolderVM
    let siblingSpacing: CGFloat = 5
    let parentSpacing: CGFloat = 5
    let basicSpacing: CGFloat = 3

    
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
        
    }
    func toggleCollapsed() {
        self.collapsed.toggle()
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
                    // add Indentation to the left to indicate depth for both folder and project
                    
                    // Collapsing Button
                    Button(action: toggleCollapsed) {
                        HStack(alignment: .bottom) {
                            Text(folder.title)
                            + Text(" \(numOfSubfolders) ")
                                .font(.caption)
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
                // Second Element in VStack
                //                if subfolders != nil && !collapsed{
                if folder.subfolders.count != 0 && !collapsed{
                    HStack {
                        ForEach((0 ..< collapsedLevel + 1), id: \.self) {_ in
//                            Text("\t")
                            Text("   ")
                        }
                        
                        VStack(spacing: 0) {
                            //                        if subfolders != nil && !collapsed{
                            ForEach(subfolders) {subfolder in
                                // if last subfolder, no padding to the bottom
                                if subfolder == subfolders.last {
                                    VerCollapsibleFolder(folder: subfolder)
                                } else {
                                
                                VerCollapsibleFolder(folder: subfolder)
                                        .environmentObject(showingMemoVM)
                                    .padding(.bottom, siblingSpacing)
                                }
                            }
                        }
                    }
//                    .padding(.top, parentSpacing)
//                    .padding(.vertical, parentSpacing / 2)
                    .animation(.easeOut, value: collapsed)
                    .transition(.slide)
                } // end of second Element in VStack (HStack)
            } // end of VStack
            Spacer()
        } // end of HStack
        .padding(basicSpacing)
        .tint(colorScheme == .dark ? .white : .black)
        .onAppear {
            print("this view has appeared")
        }
    }
}
