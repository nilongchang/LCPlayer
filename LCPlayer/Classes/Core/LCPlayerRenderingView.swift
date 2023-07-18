//
//  LCPlayerRenderingView.swift
//  LCPlayer
//
//  Created by Long on 2023/7/11.
//

import UIKit
import Foundation
import AVFoundation

public class LCPlayerRenderingView: UIView {
    
    public override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    public lazy var playerLayer: AVPlayerLayer = {
        return layer as! AVPlayerLayer
    }()
    
    private let player: AVPlayer
    required init(with player: AVPlayer) {
        self.player = player
        super.init(frame: .zero)
        self.playerLayer.player = player
        addNotification()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        translatesAutoresizingMaskIntoConstraints = false
        if let parent = superview {
            topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        }
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(removePlayerOnPlayerLayer), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetPlayerOnPlayerLayer), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func removePlayerOnPlayerLayer() {
        self.playerLayer.player = nil
    }
    
    @objc private func resetPlayerOnPlayerLayer() {
        self.playerLayer.player = player
    }
}
