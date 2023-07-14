//
//  ViewController.swift
//  LCPlayer
//
//  Created by nilongchang on 07/11/2023.
//  Copyright (c) 2023 nilongchang. All rights reserved.
//

import UIKit
import AVFoundation
import LCPlayer
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var coverImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        let assetURLs = ["https://ct-vd1.jianzhishuyuan.net//dsh/front/20230711/0063575f1e1b25007806690b46776d63.mp4",
//                         "https://ct-vd1.jianzhishuyuan.net//dsh/front/20230711/a71534a9e0e8a7cda36bb246299a00fb.mp4"].map {
//            return URL(string: $0)
//        }
//
//        self.playerController.assetURLs = assetURLs
//        self.playerController.play()
//        coverImageView.sd_setImage(with: URL(string: "https://ct2.jianzhiweike.com.cn/dsh/20230711/e4ac47ef4751ead227a79114e9da7bf6.jpg"))
    }

    @IBAction func fullAction(_ sender: UIButton) {
        let playerVC = LCPlayerViewController(url: "https://ct-vd1.jianzhishuyuan.net//dsh/front/20230711/0063575f1e1b25007806690b46776d63.mp4", title: nil, supportedOrientations: nil, presentationOrientation: nil)
        playerVC.modalPresentationStyle = .fullScreen
        present(playerVC, animated: true)
    }
    

}

// MARK: - LCPlayerPlaybackDelegate ----------------------------
extension ViewController: LCPlayerPlaybackDelegate {
    
    
    func playbackAssetLoaded(player: LCPlayer) {
        print("playbackAssetLoaded")
    }
    
    func playbackPlayerReadyToPlay(player: LCPlayer) {
        print("playbackPlayerReadyToPlay")
    }
    
    func playbackItemReadyToPlay(player: LCPlayer, item: LCPlayerItem) {
        print("playbackItemReadyToPlay: \(item)")
    }
    
    func playbackTimeDidChange(player: LCPlayer, to time: CMTime) {
        print("playbackTimeDidChange: \(time)")
    }
    
    func playbackDidBegin(player: LCPlayer) {
        print("playbackDidBegin")
    }
    
    func playbackDidPause(player: LCPlayer) {
        print("playbackDidPause")
    }
    func playbackDidEnd(player: LCPlayer) {
        print("playbackDidEnd")
    }
    
    func playbackStartBuffering(player: LCPlayer) {
        print("playbackStartBuffering")
    }
    
    func playbackLoadedTimeRanges(player: LCPlayer, progress: CGFloat) {
        print("playbackLoadedTimeRanges: \(progress)")
    }
    
    func playbackEndBuffering(player: LCPlayer) {
        print("playbackEndBuffering")
    }
    
    func playbackDidFailed(player: LCPlayer, error: Error) {
        print("playbackDidFailed")
    }
    
    
}
