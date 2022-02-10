//
//  BookMarkListView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/10.
//

import SwiftUI
import CoreData

struct BookMarkListView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: Memo.bookMarkedFetchReq()) var memos: FetchedResults<Memo>
    
    @State var bookMarkedMemos: [Memo] = []
    @State var someThing: [Memo] = []
    var body: some View {
        DispatchQueue.main.async {
            bookMarkedMemos = memos.sorted()
            someThing = Memo.fetchBookMarked(context: context)
        }
         
        
        return Section(header:
                    HStack {
            Text("BookMarked Memos")
                .padding(.vertical, Sizes.smallSpacing)
                .padding(.leading, Sizes.overallPadding)

            Spacer()
        }
        ) {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: Sizes.smallSpacing ) {
                    ForEach(someThing, id: \.self) { memo in

                        NavigationLink(destination: MemoView(memo: memo, parent: memo.folder!)

                        ) {
//                            BookMarkedMemoBoxView(memo: memo)
//                            EmptyView()
                        }
                    } // end of ForEach
                } // HStack
                .padding(.horizontal, Sizes.overallPadding)
            }
            .frame(height: 150)
        } // end of Section
    }
}

struct BookMarkListView_Previews: PreviewProvider {
    static var previews: some View {
        BookMarkListView()
    }
}
