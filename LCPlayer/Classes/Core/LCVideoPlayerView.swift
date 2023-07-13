//
//  LCVideoPlayerView.swift
//  LCPlayer
//
//  Created by Long on 2023/7/13.
//

import UIKit
import AVFoundation

public class LCVideoPlayerView: LCBasePlayerView {
    // MARK: - UI ----------------------------
    /// 关闭
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_close"), for: .normal)
        button.addTarget(self, action: #selector(closeAction(_ :)), for: .touchUpInside)
        return button
    }()

    /// 旋转
    private lazy var rotateButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_rotate"), for: .normal)
        button.addTarget(self, action: #selector(closeAction(_ :)), for: .touchUpInside)
        return button
    }()
    
    /// 开始时间
    private lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    /// 结束时间
    private lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    /// 进度
    private lazy var progressView: LCVideoPlayerSlider = {
        let view = LCVideoPlayerSlider()
        view.trackTintColor = UIColor.white.withAlphaComponent(0.5)
        view.bufferTintColor = UIColor.black.withAlphaComponent(0.5)
        view.progressTintColor = UIColor(red: 0, green: 205, blue: 220, alpha: 1)
        view.handlerBlock = { state in
            
        }
        return view
    }()
    
    var closeHander: (() -> Void)?
    var rotateHander: (() -> Void)?
    
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
        addSubview(closeButton)
        addSubview(rotateButton)
        addSubview(startTimeLabel)
        addSubview(endTimeLabel)
        addSubview(progressView)
    }
    
    private func updateLayout() {
        let width = bounds.width
        let height = bounds.height
        let timeSize = CGSize(width: 57, height: 13)
        
        
        closeButton.frame = CGRect(x: 15, y: 63, width: 32, height: 32)
        rotateButton.frame = CGRect(x: width - 24 - 17, y: height - 24 - 82, width: 24, height: 24)
        startTimeLabel.frame = CGRect(x: 0, y: height - 34, width: timeSize.width, height: timeSize.height)
        endTimeLabel.frame = CGRect(x: width - timeSize.width, y: startTimeLabel.bounds.minY, width: timeSize.width, height: timeSize.height)
        progressView.frame = CGRect(x: startTimeLabel.bounds.width, y: startTimeLabel.bounds.minY, width: width - timeSize.width * 2, height: timeSize.height)
        
    }
    
    // MARK: - Touch Event ----------------------------
    @objc private func closeAction(_ button: UIButton) {
        closeHander?()
    }
    
    @objc private func rotateAction(_ button: UIButton) {
        rotateHander?()
    }
    
    // MARK: - LCPlayerPlaybackDelegate ----------------------------
    /// 资源已加载
    public override func playbackAssetLoaded(player: LCPlayer) {
        super.playbackAssetLoaded(player: player)
    }

    /// 准备播放（可播放
    public override func playbackPlayerReadyToPlay(player: LCPlayer) {
        super.playbackPlayerReadyToPlay(player: player)
    }
    
    /// 当前item准备播放（可播放
    public override func playbackItemReadyToPlay(player: LCPlayer, item: LCPlayerItem) {
        super.playbackItemReadyToPlay(player: player, item: item)
    }
    
    /// 时间改变
    public override func playbackTimeDidChange(player: LCPlayer, to time: CMTime) {
        super.playbackTimeDidChange(player: player, to: time)
    }

    /// 播放到结束
    public override func playbackDidEnd(player: LCPlayer) {
        super.playbackDidEnd(player: player)
    }
    
    /// 开始缓冲
    public override func playbackStartBuffering(player: LCPlayer) {
        super.playbackStartBuffering(player: player)
    }
    
    /// 缓冲的进度
    public override func playbackLoadedTimeRanges(player: LCPlayer, progress: CGFloat) {
        super.playbackLoadedTimeRanges(player: player, progress: progress)
    }
    
    /// 缓存完毕
    public override func playbackEndBuffering(player: LCPlayer) {
        super.playbackEndBuffering(player: player)
    }
    
    /// 播放错误
    public override func playbackDidFailed(player: LCPlayer, error: Error) {
        super.playbackDidFailed(player: player, error: error)
    }
}


