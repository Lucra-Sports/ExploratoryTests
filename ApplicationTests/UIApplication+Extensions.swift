//
//  UIApplication+Extensions.swift
//  ApplicationTests
//
//  Created by Paul Zabelin on 5/21/22.
//

import UIKit

extension UIApplication {
    var appKeyWindow: UIWindow? {
            UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .first(where: \.isKeyWindow)
        }
}
