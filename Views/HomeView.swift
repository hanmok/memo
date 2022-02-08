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
    
    @FetchRequest(fetchRequest: Folder.topFolderFetchReq()) var topFolders: FetchedResults<Folder>
    
    var body: some View {
        
        // MARK: - FOR TESTING

        
//                UnitTestHelpers.deletesAllFolders(context: context)

        if topFolders.isEmpty {
            Folder.returnSampleFolder2(context: context)
        }
        
        
        return NavigationView {
            MindMapView(
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        targetFolders: topFolders.sorted()))
        }
    }
}



class FastFolderWithLevelGroup: ObservableObject {
    @Published var allFolders: [FolderWithLevel]
    
    init(targetFolders: [Folder]) {
        self.allFolders = Folder.getHierarchicalFolders(topFolders: targetFolders)
    }
}
