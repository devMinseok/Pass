//
//  Preview.swift
//  Pass
//
//  Created by 강민석 on 2021/03/19.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI

let deviceNames: [String] = [
    "iPhone 12 Pro Max",
    "iPhone 12 mini"
]

@available(iOS 13.0, *)
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                // MARK: -  Initalizing ViewController
                IntroViewController(reactor: IntroViewReactor())
                
            }.previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
#endif
