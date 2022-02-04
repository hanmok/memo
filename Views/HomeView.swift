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
    
    // 어디서부터 어떤게 잘못된걸까?
    var body: some View {
        
        // MARK: - FOR TESTING
        if topFolders.isEmpty {
            Folder.returnSampleFolder2(context: context)
        }
        
        //        UnitTestHelpers.deletesAllFolders(context: context)
        
        
        
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
