//
//  HomeView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/06.
//

import SwiftUI
import CoreData

// received lists from DeeepMemoAPp
/*
 .environment(\.managedObjectContext, persistenceController.container.viewContext)
 .environmentObject(NavigationStateManager())
 */

struct HomeView: View { // top folder fetch
    // previously selected Folder
    @EnvironmentObject var nav: NavigationStateManager
//    @ObservableObject var
//@StateObject var folderEditVM = FolderEditViewModel()
//    
//    @StateObject var memoEditVM = MemoEditViewModel()
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var topFolders: FetchedResults<Folder>
    
    @State var testChange = false
    @State var presentFolderOverview = false
    
//    var initialFolder: Folder
    
    var body: some View {
    
//        UnitTestHelpers.deletesAllFolders(context: context)
        
//        if nav.selectedFolder == nil  {
//            if topFolders.count != 0 {
//                nav.selectedFolder = topFolders.first!
//            } else {
//                nav.selectedFolder = Folder.returnSampleFolder(context: context)
//            }
//        }
        
        // original
//        return NavigationView {
//            FolderView(currentFolder: nav.selectedFolder!)
//                .environmentObject(MemoEditViewModel())
//                .environmentObject(FolderEditViewModel())
//                .onAppear {
//                    nav.selectedFolder!.getFolderInfo()
//                }
//        }
        
//        return MindMapView()
//            .environmentObject(FolderEditViewModel())
//            .environmentObject(MemoEditViewModel())
        
        
        // this is what i want.
        
        return NavigationView {
            MindMapView(fastFolderWithLevelGroup: FastFolderWithLevelGroup(targetFolder: topFolders.first!))
                .environmentObject(FolderEditViewModel())
        }
        
//        return TestView()
        
//        return MindMapView(homeFolder: nav.selectedFolder!)
//        return MindMapView().environmentObject(FolderEditViewModel())
        
//        return MindMapView(homeFolder: nav.selectedFolder!)
        
//        return NavigationView { MindMapView()
//            .environmentObject(FolderEditViewModel())
//        }
//        return NavigationView {
//            MindMapViewTest()
//            .environmentObject(FolderEditViewModel())
//        }
//        return MindMapViewTest()
//            .environmentObject(FolderEditViewModel())
//            .environmentObject(MemoEditViewModel())
        
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

