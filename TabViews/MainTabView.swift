//
//  MainTabView.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/05/25.
//

import Foundation
import SwiftUI
import CoreData

struct MainTabView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Folder.topFolderFetchReq()) var topFolders: FetchedResults<Folder>
    
    @EnvironmentObject var messageVM: MessageViewModel
    @AppStorage(AppStorageKeys.isFirstScreenSecondView) var isFirstScreenSecondView = false
    @Environment(\.colorScheme) var colorScheme
    
    @State var tabSelection: Tabs = .memoList
    
    init() {
        // MainTab Background Color
//            UITabBar.appearance().backgroundColor = UIColor.gray
        UITabBar.appearance().backgroundColor = .systemBackground
//        UITabBar.appearance().backgroundColor = .secondarySystemBackground
//        UITabBar.appearance().backgroundColor = .tertiarySystemBackground
        }
    
    var customImage: Image {
        return SystemImage("rectangle.split.3x1")
            .rotationEffect(.degrees(90))
            .scaleEffect(CGSize(width: 1, height: 0.8)) as! Image
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $tabSelection) {
                FirstTabView(fastFolderWithLevelGroup: FastFolderWithLevelGroup(
                    homeFolder: topFolders.filter{ FolderType.compareName($0.title, with: .folder)}.first!, // found nil here .. Why... ??
                    archiveFolder: topFolders.filter{FolderType.compareName($0.title, with: .archive)}.first!
                ), currentFolder: topFolders.filter { FolderType.compareName($0.title, with: .folder)}.first!)
                    .navigationBarHidden(true)
                    .navigationBarTitle(Text(""))
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Memo")
                }
                .tag(Tabs.memoList)
                SecondTabView(fastFolderWithLevelGroup: FastFolderWithLevelGroup(
                    homeFolder: topFolders.filter{ FolderType.compareName($0.title, with: .folder)}.first!, // found nil here .. Why... ??
                    archiveFolder: topFolders.filter{FolderType.compareName($0.title, with: .archive)}.first!
                ))
                    .navigationBarHidden(true)
                    .navigationBarTitle(Text(""))
                .tabItem {
                    Image(systemName: "folder")
                    
                    Text("Folder")
                }
                .tag(Tabs.folderList)
            }
            // tabbed Label's Color
            .accentColor(colorScheme == .dark ? .darkMain : .lightMain)
            .environmentObject(TrashBinViewModel(trashBinFolder: topFolders.filter {
                FolderType.compareName($0.title, with: .trashbin)}.first!))
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea([.top, .bottom])
        }
        // Message
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
                .frame(height: UIScreen.hasSafeBottom ? 70 : 50)
//                .frame(height: 100)
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
//                .offset(y: UITabBar.appearance().height)
            }
        }
    }
    
    enum Tabs {
        case memoList
        case folderList
        case todos
        case settings
    }
}
