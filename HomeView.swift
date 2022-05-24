//
//  HomeView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/06.
//

import SwiftUI
import CoreData

struct HomeView: View { 
//    VStack(spacing:0) {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Folder.topFolderFetchReq()) var topFolders: FetchedResults<Folder>
    
    @EnvironmentObject var messageVM: MessageViewModel
    @AppStorage(AppStorageKeys.isFirstScreenSecondView) var isFirstScreenSecondView = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        // call !
        return NavigationView {
//            FirstMainView(
            CombinedMainView(
//            MainTabView()
                fastFolderWithLevelGroup:
                    FastFolderWithLevelGroup(
                        homeFolder: topFolders.filter{ FolderType.compareName($0.title, with: .folder)}.first!, // found nil here .. Why... ??
                        archiveFolder: topFolders.filter{FolderType.compareName($0.title, with: .archive)}.first!
                    )
                ,isShowingSecondView: isFirstScreenSecondView
            )
                .environmentObject(TrashBinViewModel(trashBinFolder: topFolders.filter {
                    FolderType.compareName($0.title, with: .trashbin)}.first!))
        }
        .overlay {
            VStack {
                Spacer()
                
                ZStack {
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(colorScheme == .dark ? Color.init(white: 0.1) : .white)
                        .background(colorScheme == .dark ? Color.init(white: 0.1) : .white)

                    VStack {
                    Text(messageVM.message)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding(.top, 10)
                    Spacer()
                    }
                }
                .cornerRadius(10)
//                .frame(height: UIScreen.hasSafeBottom ? 60 : 40)
                .frame(height: UIScreen.hasSafeBottom ? 70 : 50)
                .cornerRadius(10)
                .offset(y: messageVM.shouldShow ? 0 : 100)
                .overlay(
                    VStack(spacing: 0) {
                        Rectangle().frame(
                            width: UIScreen.screenWidth,
                            height: 1,
                            alignment: .top)
                        .cornerRadius(10)
                        .foregroundColor(colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.85))
                    Spacer()
                    }
                )
                .offset(y: messageVM.shouldShow ? 0 : 100)
                
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
