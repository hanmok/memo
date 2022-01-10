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
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var folders: FetchedResults<Folder>
    // when app launched, set default folderview to home view.
    // if not exist, make one and use.
    var initialFolder: Folder {
        if nav.selectedFolder != nil {
            
            if folders.count != 0 {
                nav.selectedFolder = folders.first!
                return nav.selectedFolder!
            }
        }
        let homeFolder = Folder.createHomeFolder(context: context)
        nav.selectedFolder = homeFolder
        return homeFolder
    }
    
    var body: some View {
//        NavigationView {
//        navigationTitle(initialFolder.title)
//        NavigationView {
            FolderView(
                currentFolder: initialFolder)
//        }
            .onAppear {
                print("initialFolder.title : \(initialFolder.title)")
            }
//        }
//        .navigationTitle(initialFolder.title)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

/*
 
 HomeView()
 .environment(\.managedObjectContext, persistenceController.container.viewContext)
 .environmentObject(NavigationStateManager())
 
 */
