//
//  LCPlayerResource.swift
//  LCPlayer
//
//  Created by Long on 2023/7/14.
//

import Foundation

enum Icon: String {
    
    case close = "lcplayer_icon_close"
    case rotate = "lcplayer_icon_rotate"
    case play = "lcplayer_icon_play"
    case pause = "lcplayer_icon_pause"
    case back = "lcplayer_icon_back"
    
    /// Returns the associated image.
    var image: UIImage? {
        return UIImage(named: rawValue, in: Bundle.frameworkBundle(), compatibleWith: nil)
    }
}


// MARK: - Bundle ----------------------------
// 参考SwiftMessage
private class BundleToken {}

extension Bundle {
    // This is copied method from SPM generated Bundle.module for CocoaPods support
    static func frameworkBundle() -> Bundle {

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleToken.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        let bundleNames = [
            // For Swift Package Manager
            "LCPlayer_LCPlayer",

            // For Carthage
            "LCPlayer",
        ]

        for bundleName in bundleNames {
            for candidate in candidates {
                let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
                if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                    return bundle
                }
            }
        }

        // Return whatever bundle this code is in as a last resort.
        return Bundle(for: BundleToken.self)
    }
}
