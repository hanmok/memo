//import SwiftUI
//
//
//struct Family: Identifiable {
//    var id = UUID()
//    var name: String
//}
//
//struct FamilyRow: View {
//    var family: Family
//    var body: some View {
//        Text("Family: \(family.name)")
//    }
//}
//
//struct ListTestView: View {
//    var body: some View {
//        let first = Family(name: "Hohyeon")
//        let second = Family(name: "Gomin")
//        let third = Family(name: "Durup")
//        let families = [first, second, third]
//
//        return List(families) { family in
//            FamilyRow(family: family)
//                .swipeActions(edge: .leading, allowsFullSwipe: true) {
//                    Button(action: {
//                        print("hi")
//                    }) {
//                        Text("hello")
//                    }
//                }
//        }
//    }
//}
