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
        view.playerControls.topBar.titleLabel.text = videoTitle
        view.playerControls.topBar.backHander = { [weak self] in
            guard let self = self else { return }
            let orientation = self.currentInterfaceOrientation()
            if orientation.isLandscape {
                self.exitFullScreen()
            } else {
                self.dismiss(animated: true)
            }
        }
        // 旋转
        view.playerControls.rotateHander = { [weak self] in
            guard let self = self else { return }
            let orientation = self.currentInterfaceOrientation()
            if orientation.isLandscape {
                self.exitFullScreen()
            } else {
                self.enterFullScreen()
            }
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
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public override var prefersStatusBarHidden: Bool {
        return false
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
    
    func enterFullScreen(_ animated: Bool = true){
        if #available(iOS 16.0, *) {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            let orientation = scene.effectiveGeometry.interfaceOrientation
            debugPrint("orientation:\(orientation) isPortrait:\(orientation.isPortrait)")
            if orientation.isPortrait {
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
                self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .landscapeRight)
                scene.requestGeometryUpdate(geometryPreferences) { error in
                    debugPrint(error.localizedDescription)
                }
            }
            
        } else {
            let orientation = UIDevice.current.orientation
            debugPrint("orientation:\(orientation) isPortrait:\(orientation.isPortrait)")
            if orientation.isPortrait {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                self.setNeedsStatusBarAppearanceUpdate()
                UIViewController.attemptRotationToDeviceOrientation()                
            }
        }
    }
    
    func exitFullScreen(_ animated: Bool = true){
        if #available(iOS 16.0, *) {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            let orientation = scene.effectiveGeometry.interfaceOrientation
            debugPrint("orientation:\(orientation) isLandscape:\(orientation.isLandscape)")
            if orientation.isLandscape {
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
                self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                
                debugPrint("error.localizedDescription")
                
                let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .portrait)
                scene.requestGeometryUpdate(geometryPreferences) { error in
                    debugPrint(error.localizedDescription)
                }
            }
            
        } else {
            let orientation = UIDevice.current.orientation
            debugPrint("orientation:\(orientation) isLandscape:\(orientation.isLandscape)")
            if orientation.isLandscape {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                self.setNeedsStatusBarAppearanceUpdate()
                UIViewController.attemptRotationToDeviceOrientation()
            }
        }
    }
    
    func currentInterfaceOrientation() -> UIInterfaceOrientation {
        if #available(iOS 16.0, *) {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return preferredInterfaceOrientationForPresentation }
            return scene.effectiveGeometry.interfaceOrientation
            
        } else {
            return UIInterfaceOrientation(rawValue: UIDevice.current.orientation.rawValue) ?? preferredInterfaceOrientationForPresentation
        }
    }
}
