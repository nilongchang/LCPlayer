//
//  LCPlayerRenderingView.swift
//  LCPlayer
//
//  Created by Long on 2023/7/11.
//

import UIKit
import AVFoundation

public class LCPlayerRenderingView: UIView {
    
    public override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    public lazy var playerLayer: AVPlayerLayer = {
        return layer as! AVPlayerLayer
    }()
    
    required init(with player: AVPlayer) {
        super.init(frame: .zero)
        self.playerLayer.player = player
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
