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
    // MARK: - TintColor
    func adjustTintColor(scheme: ColorScheme) -> some View {
        self
            .tint(scheme == .dark ? .white : .black)
    }
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


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
            clipShape( RoundedCorner(radius: radius, corners: corners) )
        }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}




struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
}

//struct

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}



extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}



//extension UIApplication {
//    func endEditing() {
//        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//
//
//    }
//
//    func startEditing() {
//        sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
//    }
//}


