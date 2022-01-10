//
//  ChangeMemoVarsTestView.swift
//  DeeepMemo
//
//  Created by 이한목 on 2022/01/10.
//

import SwiftUI

struct ChangeMemoVarsTestView: View {
    
    @Environment(\.managedObjectContext) var context
    var memo: Memo
    @State private var title: String = ""
    @State private var overview: String = ""
    @State private var contents: String = ""
    
    
    func saveChange() {
//        folder.title = folderName
        memo.title = title
        memo.overview = overview
        memo.contents = contents
        
        context.saveCoreData()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Title")
                TextField(memo.title, text: $title)
            }
            .padding()
            HStack {
                Text("Overview")
                TextField(memo.overview, text: $overview)
            }
            .padding()
            HStack {
                Text("Contents")
                TextField(memo.contents, text: $contents)
            }
            .padding()
        }
    }
}

struct ChangeMemoVarsTestView_Previews: PreviewProvider {
    
    static var sampleMemo = Memo(title: "sample Memo",contents: "test contents", context: PersistenceController.preview.container.viewContext)
    
    static var previews: some View {
        ChangeMemoVarsTestView(memo: sampleMemo)
    }
}
