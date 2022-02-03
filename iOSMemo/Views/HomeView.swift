//
//  HomeView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/06.
//

import SwiftUI
import CoreData

struct HomeView: View { // top folder fetch

    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var topFolders: FetchedResults<Folder>
    
//    var initialFolder: Folder
    
//    init(context: NSManagedObjectContext) {
//        let req = Folder.topFolderFetch()
//        let res = try? context.fetch(req)
//        if let validFolder = res {
//            if validFolder.count != 0 {
//                initialFolder = validFolder.first!
//            } else {
//                initialFolder = Folder.createHomeFolder(context: context)
//            }
//        }
//        initialFolder = Folder.createHomeFolder(context: context)
//    }
    
    // 어디서부터 어떤게 잘못된걸까?
    var body: some View {


        
//        UnitTestHelpers.deletesAllFolders(context: context)
        
//        var initialFolder: Folder
        
//        if topFolders.count != 0 {
//            initialFolder = topFolders.first!
//            print("topFolders: \(topFolders)")
//            print("topFolder.title :\(topFolders.first!.title)")
////            initialFolder = Folder.returnSampleFolder(context: context)
//        } else {
//            initialFolder = Folder.createHomeFolder(context: context)
////            initialFolder = Folder.returnSampleFolder(context: context)
////            initialFolder = Folder.returnSampleFolder(context: context)
//        }
        
        
//        if topFolders.count != 0 {
//            print("triggered line : 40")
//
//            return NavigationView {
////                MindMapView(
////                    fastFolderWithLevelGroup:
////                        FastFolderWithLevelGroup(
////                            targetFolder: topFolders.first!))
//                MindMapView(
//                    fastFolderWithLevelGroup:
//                        FastFolderWithLevelGroup(
//                            targetFolder: Folder.returnSampleFolder(context: context)))
//            }
//        } else {
//            print("triggered line : 48")
//            return NavigationView {
//                MindMapView(
//                    fastFolderWithLevelGroup:
//                        FastFolderWithLevelGroup(
//                            targetFolder: Folder.createHomeFolder(context: context)))
//        }
        
//        MindMapView(
//            fastFolderWithLevelGroup:
//                FastFolderWithLevelGroup(
//                    targetFolder: Folder.returnSampleFolder(context: context)))

//        if topFolders.count != 0 {
//        return MindMapView(
//            fastFolderWithLevelGroup:
//                FastFolderWithLevelGroup(
//                    targetFolder: Folder.returnSampleFolder(context: context)))
//        } else {
//            return MindMapView(
//                fastFolderWithLevelGroup:
//                    FastFolderWithLevelGroup(
//                        targetFolder: Folder.returnSampleFolder(context: context)))
//        }
        
//        return MindMapView(
//            fastFolderWithLevelGroup:
//                FastFolderWithLevelGroup(
//                    targetFolder: Folder.returnSampleFolder(context: context)))
        
//        return NavigationView {
//            MindMapView(
//            fastFolderWithLevelGroup:
//                FastFolderWithLevelGroup(
//                    targetFolder: initialFolder))
//        }
        
//        return NavigationView {
//            MindMapView(
//            fastFolderWithLevelGroup:
//                FastFolderWithLevelGroup(
//                    targetFolder: topFolders.first!))
//        }
        
//        return NavigationView {
//            MindMapView(
//            fastFolderWithLevelGroup:
//                FastFolderWithLevelGroup(
//                    targetFolder: Folder.returnSampleFolder(context: context)))
//        }
        
        return NavigationView {
//            ZStack {
//                MindMapView(
//                    fastFolderWithLevelGroup:
//                        FastFolderWithLevelGroup(
//                            targetFolder: topFolders.first!))
                
//                MindMapView(
//                    fastFolderWithLevelGroup:
//                        FastFolderWithLevelGroup(
//                            targetFolder: Folder.returnSampleFolder(context: context)))
            
//            MindMapView(
//                fastFolderWithLevelGroup:
//                    FastFolderWithLevelGroup(
//                        targetFolder: topFolders.first!))
            
            MindMapView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        targetFolders: topFolders.sorted()))
            
//            MindMapView(
//                fastFolderWithLevelGroup:
//                    FastFolderWithLevelGroup(
//                        targetFolders: [Folder(title: "home", context: context)]))
            
                
//                VStack {
//                    Spacer()
//                    ForEach(topFolders.first!.subfolders.sorted()) { subFolder in
//                        Text(subFolder.title)
//                            .background(.green)
//                    }
//                }
            }
        }

//        return EmptyView()
//
//        return NavigationView {
//            MindMapView(
//                fastFolderWithLevelGroup:
//                    FastFolderWithLevelGroup(
//                        targetFolder: initialFolder))

        
                
//        return NavigationView {
//            MindMapView(
//                fastFolderWithLevelGroup:
//                    FastFolderWithLevelGroup(
//                        targetFolder: topFolders.first!))
//                .environmentObject(FolderEditViewModel())
        }



class FastFolderWithLevelGroup: ObservableObject {
    @Published var allFolders: [FolderWithLevel]
//    @Published var targetFolder: Folder
    init(targetFolders: [Folder]) {
        self.allFolders = Folder.getHierarchicalFolders(topFolders: targetFolders)
    }
}





////
////  HomeView.swift
////  DeeepMemo
////
////  Created by Mac mini on 2022/01/06.
////
//
//import SwiftUI
//import CoreData
//
//// received lists from DeeepMemoAPp
///*
// .environment(\.managedObjectContext, persistenceController.container.viewContext)
// .environmentObject(NavigationStateManager())
// */
//
//struct HomeView: View { // top folder fetch
//    // previously selected Folder
//    @EnvironmentObject var nav: NavigationStateManager
////    @ObservableObject var
////@StateObject var folderEditVM = FolderEditViewModel()
////
////    @StateObject var memoEditVM = MemoEditViewModel()
//
//    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
//
//    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var topFolders: FetchedResults<Folder>
//
//    @State var testChange = false
//    @State var presentFolderOverview = false
//
////    var initialFolder: Folder
//
//    var body: some View {
//
////        UnitTestHelpers.deletesAllFolders(context: context)
//
////        if nav.selectedFolder == nil  {
////            if topFolders.count != 0 {
////                nav.selectedFolder = topFolders.first!
////            } else {
////                nav.selectedFolder = Folder.returnSampleFolder(context: context)
////            }
////        }
//
//        // original
////        return NavigationView {
////            FolderView(currentFolder: nav.selectedFolder!)
////                .environmentObject(MemoEditViewModel())
////                .environmentObject(FolderEditViewModel())
////                .onAppear {
////                    nav.selectedFolder!.getFolderInfo()
////                }
////        }
//
////        return MindMapView()
////            .environmentObject(FolderEditViewModel())
////            .environmentObject(MemoEditViewModel())
//
//
//        // this is what i want.
//
//        return NavigationView {
//            MindMapView(fastFolderWithLevelGroup: FastFolderWithLevelGroup(targetFolder: topFolders.first!))
//                .environmentObject(FolderEditViewModel())
//        }
//
////        return TestView()
//
////        return MindMapView(homeFolder: nav.selectedFolder!)
////        return MindMapView().environmentObject(FolderEditViewModel())
//
////        return MindMapView(homeFolder: nav.selectedFolder!)
//
////        return NavigationView { MindMapView()
////            .environmentObject(FolderEditViewModel())
////        }
////        return NavigationView {
////            MindMapViewTest()
////            .environmentObject(FolderEditViewModel())
////        }
////        return MindMapViewTest()
////            .environmentObject(FolderEditViewModel())
////            .environmentObject(MemoEditViewModel())
//
//    }
//}
//
////struct HomeView_Previews: PreviewProvider {
////    static var previews: some View {
////        HomeView()
////    }
////}
//
