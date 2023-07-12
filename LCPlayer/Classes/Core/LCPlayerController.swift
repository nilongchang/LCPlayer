//
//  LCPlayerController.swift
//  LCPlayer
//
//  Created by Long on 2023/7/11.
//

import UIKit
import AVFoundation

public class LCPlayerController: NSObject {
    /// player
    public lazy var player: LCPlayer = {
        let player = LCPlayer()
        player.setupPlayer()
        return player
    }()
    weak var containerView: UIView?
    
    /// assetURLs
    public var assetURLs: [URL?]?
    public var currentPlayIndex: Int = 0
    
    
    public init(containerView: UIView) {
//        self.containerView = containerView
        
        
        super.init()
        let renderingView = LCPlayerRenderingView(with: player)
        containerView.insertSubview(renderingView, at: 0)
    }
    
    public func play() {
        play(at: self.currentPlayIndex)
    }
    
    public func play(at index: Int) {
        guard let assetURLs = assetURLs, index < assetURLs.count - 1, let url = assetURLs[index] else { return }
        self.currentPlayIndex = index
        let item = LCPlayerItem(url: url)        
        player.replaceCurrentItem(with: item)
        player.play()
        print("play \(index) \(item.error?.localizedDescription) \(url)")
    }
    
}
