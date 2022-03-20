
import SwiftUI


struct FolderOrderingButton: View {
    
    @AppStorage(AppStorageKeys.fOrderType) var folderOrderType = OrderType.creationDate

    @Environment(\.managedObjectContext) var context
    
    var type: OrderType

    
    var body: some View {
        
        Button {
            folderOrderType = type
            Folder.updateTopFolders(context: context)
        } label: {
            HStack {
                if folderOrderType == type {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(LocalizedStringStorage.convertOrderTypeToStorage(type: type))
            }
        }
    }
}
