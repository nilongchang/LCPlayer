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
    /// 控制uiview
    public lazy var playerControls: LCVideoPlayerControls = {
        let view = LCVideoPlayerControls()
        // 关闭
        view.closeHander = {

        }
        // 播放/暂停
        view.playOrPauseHander = {[weak self] isPlay in
            if isPlay {
                self?.play()
            }else {
                self?.pause()
            }
        }
        // 旋转
        view.rotateHander = {

        }
        
        view.bottomBar.progressView.handlerBlock = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .changed(progress: let progress):
                let time = self.player.endTime() * progress
                let text = self.textWithTime(time: time)
                debugPrint("changed(progress: \(progress) \(time) \(text)")
                self.playerControls.bottomBar.startTimeLabel.text = text
                break
            case .onTap(progress: let progress):
                self.isBeginDrag = true
                self.seekToProgress(progress, completionHandler: { isFinish in
                    self.isBeginDrag = false
                })
                break
           
            case .began(progress: let progress):
                self.isBeginDrag = true
                break
            case .ended(progress: let progress):
                
                self.seekToProgress(progress, completionHandler: { isFinish in
                    self.isBeginDrag = false
                })
                break
            case .cancel:
                self.isBeginDrag = false
                break
            }
        }
        return view
    }()
    /// 时间formatter
    private let formatter = DateFormatter()
    /// 是否开始拖拽
    var isBeginDrag = false
    
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
        playerControls.frame = bounds
    }
    
    private func setupUI() {
        addSubview(playerControls)
        
    }
    // MARK: - Private Method ----------------------------
    
    /// 播放progress
    /// - Parameter progress: 进度
    private func seekToProgress(_ progress: CGFloat, completionHandler: @escaping (Bool) -> Void) {
        let time = player.endTime() * progress
        playerControls.bottomBar.startTimeLabel.text = textWithTime(time: time)
        seek(to: time, completionHandler: completionHandler)
    }
    // 时间
    private func textWithTime(time: TimeInterval) -> String {
        var timeFormat: String = "HH:mm:ss"
        if time <= 3599 {
            timeFormat = "mm:ss"
        }
        let date = Date(timeIntervalSince1970: time)
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        formatter.dateFormat = timeFormat
        return formatter.string(from: date)
    }
    
    // MARK: - NetworkSpeedMonitorProtocol ----------------------------
    /// 下载速度
    /// - Parameter octets: 速度
    public override func didReceived(octets: UInt32) {
        let speed = "加载中...\(formatSpeed(octets: octets))"
        playerControls.loadingView.speedLabel.text = speed
//        print(downloadSpeed)
    }
    
    // MARK: - LCPlayerPlaybackDelegate ----------------------------
    /// 资源已加载
    public override func playbackAssetLoaded(player: LCPlayer) {
        super.playbackAssetLoaded(player: player)
        debugPrint("playbackAssetLoaded")
        netSpeed.begin()
        playerControls.startLoading()
    }

    /// 准备播放（可播放
    public override func playbackPlayerReadyToPlay(player: LCPlayer) {
        super.playbackPlayerReadyToPlay(player: player)
        debugPrint("playbackPlayerReadyToPlay")
    }
    
    /// 当前item准备播放（可播放
    public override func playbackItemReadyToPlay(player: LCPlayer, item: LCPlayerItem) {
        super.playbackItemReadyToPlay(player: player, item: item)
        debugPrint("playbackItemReadyToPlay")
        playerControls.bottomBar.startTimeLabel.text = textWithTime(time: player.startTime())
        playerControls.bottomBar.endTimeLabel.text = textWithTime(time: player.endTime())
    }
    
    /// 时间改变
    public override func playbackTimeDidChange(player: LCPlayer, to time: CMTime) {
        super.playbackTimeDidChange(player: player, to: time)
        debugPrint("playbackTimeDidChange")
        if !isBeginDrag {
            playerControls.bottomBar.startTimeLabel.text = textWithTime(time: player.startTime())
            playerControls.bottomBar.progressView.progress = time.seconds / player.endTime()
        }
    }
    
    /// 开始播放（点击 play
    public override func playbackDidBegin(player: LCPlayer) {
        super.playbackDidBegin(player: player)
        debugPrint("playbackDidBegin")
        playerControls.playOrPauseButton.isSelected = true
    }
    
    /// 暂停播放 （点击 pause
    public override func playbackDidPause(player: LCPlayer) {
        super.playbackDidPause(player: player)
        debugPrint("playbackDidPause")
        playerControls.playOrPauseButton.isSelected = false
    }
    /// 播放到结束
    public override func playbackDidEnd(player: LCPlayer) {
        super.playbackDidEnd(player: player)
        debugPrint("playbackDidEnd")
        playerControls.playOrPauseButton.isSelected = false
        netSpeed.stop()
    }
    
    /// 开始缓冲
    public override func playbackStartBuffering(player: LCPlayer) {
        super.playbackStartBuffering(player: player)
        debugPrint("playbackStartBuffering")
        playerControls.startLoading()
    }
    
    /// 缓冲的进度
    public override func playbackLoadedTimeRanges(player: LCPlayer, progress: CGFloat) {
        super.playbackLoadedTimeRanges(player: player, progress: progress)
        debugPrint("playbackLoadedTimeRanges")
        playerControls.bottomBar.progressView.bufferProgress = progress
    }
    
    /// 缓存完毕
    public override func playbackEndBuffering(player: LCPlayer) {
        super.playbackEndBuffering(player: player)
        playerControls.stopLoading()
        debugPrint("playbackEndBuffering")
    }
    
    /// 播放错误
    public override func playbackDidFailed(player: LCPlayer, error: Error) {
        super.playbackDidFailed(player: player, error: error)
        playerControls.playOrPauseButton.isSelected = false
        debugPrint("playbackDidFailed")
        netSpeed.stop()
        playerControls.startLoading()
        playerControls.loadingView.speedLabel.text = "失败"
    }
}


