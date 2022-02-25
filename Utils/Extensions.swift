//
//  Extensions.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/29.
//

import Foundation
import SwiftUI

extension Image {
    func setupAdditional(scheme: ColorScheme, size: CGFloat = 20) -> some View {
        self
            .addMode()
            .adjustTintColor(scheme: scheme)
            .frame(width: size , height: size)
    }
    
    func addMode(contentMode: ContentMode = .fit) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}

extension View {
    
}

extension View {
    // MARK: - TintColor
    func adjustTintColor(scheme: ColorScheme) -> some View {
        self
            .tint(scheme == .dark ? .white : .black)
    }
    
    // MARK: - Capture
//    func snapshot() -> UIImage {
//        let controller = UIHostingController(rootView: self)
//        let view = controller.view
//
//        let targetSize = controller.view.intrinsicContentSize
//        view?.bounds = CGRect(origin: .zero, size: targetSize)
//        view?.backgroundColor = .clear
//
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//
//        return renderer.image { _ in
//            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
//
//    func saveInPhoto(img: UIImage) {
//            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
//        }

}




func convertSetToArray(set: Set<Memo>) -> Array<Memo> {
    
    var emptyMemo: [Memo] = []
    _ = set.map { emptyMemo.append($0)}
    
    return emptyMemo
}

func convertSetToArray(set: Set<Folder>) -> Array<Folder> {
    var emptyFolder: [Folder] = []
    
    _ = set.map { emptyFolder.append($0)}
    
    return emptyFolder
}

