//
//  LCVideoPlayerControls.swift
//  LCPlayer
//
//  Created by Long on 2023/7/14.
//

import UIKit

public class LCVideoPlayerControls: UIView {
    public lazy var topBar: ControlTopBarView = {
        let topBar = ControlTopBarView()
        return topBar
    }()
    
    public lazy var bottomBar: ControlBottomBarView = {
        let bottomBar = ControlBottomBarView()
        return bottomBar
    }()
    
    /// 关闭
    public lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(Icon.close.image, for: .normal)
        button.addTarget(self, action: #selector(closeAction(_ :)), for: .touchUpInside)
        return button
    }()

    /// 旋转
    public lazy var rotateButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(Icon.rotate.image, for: .normal)
        button.addTarget(self, action: #selector(closeAction(_ :)), for: .touchUpInside)
        return button
    }()
    
    /// 播放 / 暂停
    public lazy var playOrPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.play.image, for: .selected)
        button.setImage(Icon.pause.image, for: .normal)
        button.addTarget(self, action: #selector(playOrPauseAction(_ :)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    /// 网速
    public lazy var loadingView: LCPlayerLoadingView = {
        let view = LCPlayerLoadingView()
        view.isHidden = true
        return view
    }()
    /// 关闭回调
    public var closeHander: (() -> Void)?
    /// 旋转回调
    public var rotateHander: (() -> Void)?
    /// 播放 / 暂停回调
    public var playOrPauseHander: ((_ isPlay: Bool) -> Void)?
    
    // MARK: - Data ----------------------------
    /// 顶部高度
    var safeTopBarHeight: CGFloat {
        return topWindow()?.safeAreaInsets.top ?? 0
    }
    
    /// 底部高度
    var safeBottomBarHeight: CGFloat {
        return topWindow()?.safeAreaInsets.bottom ?? 0
    }
    
    /// isSafeAreaMode
    private func isSafeAreaMode() -> Bool {
        return topWindow()?.safeAreaInsets.top ?? 0.0 > 0
    }
    
    /// top Window
    private func topWindow() -> UIView? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .last?.windows
                .filter({ $0.isKeyWindow })
                .last
        }else {
            return UIApplication.shared.keyWindow
        }
    }
    // MARK: - Life Cycle ----------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    private func setupUI() {
        addSubview(playOrPauseButton)
        addSubview(topBar)
        addSubview(bottomBar)
        addSubview(closeButton)
        addSubview(rotateButton)
        addSubview(loadingView)
    }
    
    private func updateLayout() {
        let width = bounds.width
        let height = bounds.height
        
        playOrPauseButton.frame = bounds
        closeButton.frame = CGRect(x: 15, y: safeTopBarHeight + 30, width: 32, height: 32)
        rotateButton.frame = CGRect(x: width - 24 - 17, y: height - 24 - 78 - safeBottomBarHeight, width: 24, height: 24)
        topBar.frame = CGRect(x: 0, y: safeTopBarHeight, width: width, height: 44)
        bottomBar.frame = CGRect(x: 0, y: height - safeBottomBarHeight - 23 - 30, width: width, height: 23)
        loadingView.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        loadingView.center = center
    }
    
    public func startLoading() {
        loadingView.isHidden = false
//        loadingView.speedLabel.text = text
    }
    
    public func stopLoading() {
        loadingView.isHidden = true
    }
    
    // MARK: - Touch Event ----------------------------
    @objc private func closeAction(_ button: UIButton) {
        closeHander?()
    }
    
    @objc private func rotateAction(_ button: UIButton) {
        rotateHander?()
    }
    
    @objc private func playOrPauseAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        playOrPauseHander?(button.isSelected)
    }
    
}

public class ControlTopBarView: UIView {
    /// 返回
    public lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.back.image, for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle ----------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backButton.center.y = bounds.height / 2
    }
    
    private func setupUI() {
        addSubview(backButton)
    }
}

public class ControlBottomBarView: UIView {
    /// 开始时间
    public lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "00:00"
        label.textAlignment = .center
        return label
    }()
    
    /// 结束时间
    public lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "00:00"
        label.textAlignment = .center
        return label
    }()
    
    /// 进度
    public lazy var progressView: LCVideoPlayerSlider = {
        let view = LCVideoPlayerSlider()
        view.thumbImage = UIImage(color: UIColor.white, size: CGSize(width: 20, height: 20))
        view.trackTintColor = UIColor.white.withAlphaComponent(0.5)
        view.bufferTintColor = UIColor.white.withAlphaComponent(0.51)
        view.progressTintColor = UIColor(red: 0, green: 205, blue: 220, alpha: 1)
        return view
    }()
    
    // MARK: - Life Cycle ----------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    private func setupUI() {
        addSubview(startTimeLabel)
        addSubview(endTimeLabel)
        addSubview(progressView)
    }
    
    private func updateLayout() {
        let width = bounds.width
        let height = bounds.height
        let timeSize = CGSize(width: 57, height: 13)
        
        startTimeLabel.frame = CGRect(x: 0, y: height - 34, width: timeSize.width, height: timeSize.height)
        endTimeLabel.frame = CGRect(x: width - timeSize.width, y: startTimeLabel.bounds.minY, width: timeSize.width, height: timeSize.height)
        progressView.frame = CGRect(x: startTimeLabel.bounds.width, y: startTimeLabel.bounds.minY, width: width - timeSize.width * 2, height: timeSize.height)
        
        startTimeLabel.center.y = height / 2
        endTimeLabel.center.y = height / 2
        progressView.center.y = height / 2
    }
}
