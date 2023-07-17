//
//  LCPlayerViewController.swift
//  LCPlayer
//
//  Created by Long on 2023/7/13.
//

import UIKit
import AVFAudio


public class LCPlayerViewController: UIViewController {
    // MARK: - UI ----------------------------
    public lazy var playerView: LCVideoPlayerView = {
        let view = LCVideoPlayerView()
        view.backgroundColor = UIColor.black
        view.playerControls.closeHander = { [weak self] in
            self?.dismiss(animated: true)
        }
        return view
    }()
    // MARK: - Data's ----------------------------
    private let videoUrl: String
    private var videoTitle: String?
    // 支持的方向
    private var supportedOrientations: UIInterfaceOrientationMask?
    // present的方向
    private var presentationOrientation: UIInterfaceOrientation?
    
    // MARK: - Life Cycle ----------------------------
    /// 初始化video page
    /// - Parameters:
    ///   - videoUrl: 视频url
    ///   - title: 标题
    ///   - supportedOrientations: 支持的方向
    ///   - presentationOrientation: present的方向
    public init(url: String,
                title: String? = nil,
                supportedOrientations: UIInterfaceOrientationMask? = nil,
                presentationOrientation: UIInterfaceOrientation? = nil) {
        self.videoUrl = url
        self.videoTitle = title
        // 如果外部传进来有值，则取外部的
        self.supportedOrientations = supportedOrientations
        self.presentationOrientation = presentationOrientation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        self.view = self.playerView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        startPlay()
    }

    open override var shouldAutorotate: Bool {
        return super.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let customSupport = supportedOrientations {
            return customSupport
        }else {
            return super.supportedInterfaceOrientations
        }
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let presentationOrientation = presentationOrientation {
            return presentationOrientation
        }else {
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    func initData() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback)
        try? session.setActive(true)
    }
    
    /// 开始播放
    private func startPlay() {
        guard let url = URL(string: videoUrl) else { return }
        let item = LCPlayerItem(url: url)
        playerView.setItem(item)
    }
}
