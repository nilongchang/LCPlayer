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
    
    /// 错误
    public lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    /// 旋转
    public lazy var rotateButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.rotate.image, for: .normal)
        button.addTarget(self, action: #selector(rotateAction(_ :)), for: .touchUpInside)
        return button
    }()

    /// 网速
    public lazy var loadingView: LCPlayerLoadingView = {
        let view = LCPlayerLoadingView()
        view.isHidden = true
        return view
    }()
    
    /// 旋转回调
    public var rotateHander: (() -> Void)?
    
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
        addSubview(errorLabel)
        addSubview(topBar)
        addSubview(bottomBar)
        addSubview(rotateButton)
        addSubview(loadingView)
    }
    
    private func updateLayout() {
        let width = frame.width
        let height = frame.height
        
        errorLabel.frame = bounds
        rotateButton.frame = CGRect(x: width - 44 - 17, y: height - 44 - 78 - safeBottomBarHeight, width: 44, height: 44)
        topBar.frame = CGRect(x: 0, y: 0, width: width, height: 44)
        bottomBar.frame = CGRect(x: 0, y: height - 23, width: width, height: 23)
        loadingView.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        loadingView.center = center
    }
    
    public func startLoading() {
        loadingView.isHidden = false
    }
    
    public func stopLoading() {
        loadingView.isHidden = true
    }
    
    
    /// 显示错误
    /// - Parameter error: 错误
    public func showError(_ error: Error) {
        errorLabel.isHidden = false
        errorLabel.text = error.localizedDescription
        bottomBar.isUserInteractionEnabled = false
    }
    
    // MARK: - Touch Event ----------------------------
    @objc private func rotateAction(_ button: UIButton) {
        rotateHander?()
    }
    
}

public class ControlTopBarView: UIView {
    /// 返回
    public lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.back.image, for: .normal)
        button.addTarget(self, action: #selector(backAction(_ :)), for: .touchUpInside)
        return button
    }()
    
    /// 标题时间
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    /// 返回回调
    public var backHander: (() -> Void)?
    
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
        
        let width = frame.width
        let height = frame.height
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: height)
        titleLabel.frame = CGRect(x: backButton.frame.width, y: 0, width: width - backButton.frame.width, height: height)
    }
    
    private func setupUI() {
        addSubview(backButton)
        addSubview(titleLabel)
    }
    
    // MARK: - Touch Event ----------------------------
    @objc private func backAction(_ button: UIButton) {
        backHander?()
    }
}

public class ControlBottomBarView: UIView {
    
    /// 播放 / 暂停
    public lazy var playOrPauseButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(Icon.play.image, for: .selected)
        button.setBackgroundImage(Icon.pause.image, for: .normal)
        button.addTarget(self, action: #selector(playOrPauseAction(_ :)), for: .touchUpInside)
        return button
    }()
    
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
    
    /// 播放 / 暂停回调
    public var playOrPauseHander: ((_ isPlay: Bool) -> Void)?
    
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
        addSubview(startTimeLabel)
        addSubview(endTimeLabel)
        addSubview(progressView)
    }
    
    private func updateLayout() {
        let width = frame.width
        let height = frame.height
        let timeSize = CGSize(width: 57, height: 13)
        
        playOrPauseButton.frame = CGRect(x: 16, y: 0, width: height, height: height)
        startTimeLabel.frame = CGRect(x: playOrPauseButton.frame.maxX, y: height - 34, width: timeSize.width, height: timeSize.height)
        endTimeLabel.frame = CGRect(x: width - timeSize.width, y: startTimeLabel.frame.minY, width: timeSize.width, height: timeSize.height)
        progressView.frame = CGRect(x: startTimeLabel.frame.maxX, y: startTimeLabel.frame.minY, width: width - endTimeLabel.frame.width - startTimeLabel.frame.maxX, height: timeSize.height)
        
        startTimeLabel.center.y = height / 2
        endTimeLabel.center.y = height / 2
        progressView.center.y = height / 2
    }

    // MARK: - Touch Event ----------------------------
    @objc private func playOrPauseAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        playOrPauseHander?(button.isSelected)
    }
}
