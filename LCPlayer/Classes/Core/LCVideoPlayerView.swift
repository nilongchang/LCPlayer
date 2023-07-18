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

        // 播放/暂停
        view.bottomBar.playOrPauseHander = {[weak self] isPlay in
            if isPlay {
                self?.play()
            }else {
                self?.pause()
            }
        }
        
        view.bottomBar.progressView.handlerBlock = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .changed(progress: let progress):
                let time = self.player.endTime() * progress
                let text = self.textWithTime(time: time)
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
    
    /// 网速监控
    public lazy var netSpeed: NetworkSpeedMonitor = {
        let netSpeed = NetworkSpeedMonitor()
        netSpeed.delegate = self
        return netSpeed
    }()
    
    /// 时间formatter
    private let formatter = DateFormatter()
    /// 是否开始拖拽
    var isBeginDrag = false
    
    // -----------------Public-----------------------
    /// 播放返回代理
    public weak var playbackDelegate: LCPlayerPlaybackDelegate?
    
    // MARK: - Life Cycle ----------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    deinit {
        netSpeed.stop()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = frame.width
        let height = frame.height
        playerControls.frame = CGRect(x: safeAreaInsets.left, y: safeAreaInsets.top, width: width - safeAreaInsets.left - safeAreaInsets.right, height: height - safeAreaInsets.top - safeAreaInsets.bottom)
    }
    
    private func setupUI() {
        player.playbackDelegate = self
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
    
    /// 时间格式化
    /// - Parameter time: 时间
    /// - Returns: 时间
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
    
    /// 网速格式化
    /// - Parameter octets: 速度
    /// - Returns: 网速
    private func formatSpeed(octets: UInt32) -> String {
        var speedString = ""
        if octets < 1024 {
            speedString = String(format: "%lludB/S", octets)
        } else if octets >= 1024 && octets < 1024 * 1024 {
            speedString = String(format: "%lluKB/S", octets / 1024)
        } else if octets >= 1024 * 1024 {
            speedString = String(format: "%lluMB/S", octets / (1024*1024))
        }
        return speedString
    }
}

// MARK: - LCPlayerPlaybackDelegate ----------------------------
extension LCVideoPlayerView: LCPlayerPlaybackDelegate {
    /// 资源已加载
    public func playbackAssetLoaded(player: LCPlayer) {
        //debugPrint("playbackAssetLoaded")
        netSpeed.begin()
        playerControls.startLoading()
    }

    /// 准备播放（可播放
    public func playbackPlayerReadyToPlay(player: LCPlayer) {
        //debugPrint("playbackPlayerReadyToPlay")
    }
    
    /// 当前item准备播放（可播放
    public func playbackItemReadyToPlay(player: LCPlayer, item: LCPlayerItem) {
        //debugPrint("playbackItemReadyToPlay")
        playerControls.bottomBar.startTimeLabel.text = textWithTime(time: player.startTime())
        playerControls.bottomBar.endTimeLabel.text = textWithTime(time: player.endTime())
    }
    
    /// 时间改变
    public func playbackTimeDidChange(player: LCPlayer, to time: CMTime) {
        //debugPrint("playbackTimeDidChange")
        if !isBeginDrag {
            playerControls.bottomBar.startTimeLabel.text = textWithTime(time: player.startTime())
            playerControls.bottomBar.progressView.progress = time.seconds / player.endTime()
        }
    }
    
    /// 开始播放（点击 play
    public func playbackDidBegin(player: LCPlayer) {
        //debugPrint("playbackDidBegin")
        playerControls.bottomBar.playOrPauseButton.isSelected = true
    }
    
    /// 暂停播放 （点击 pause
    public func playbackDidPause(player: LCPlayer) {
        //debugPrint("playbackDidPause")
        playerControls.bottomBar.playOrPauseButton.isSelected = false
    }
    /// 播放到结束
    public func playbackDidEnd(player: LCPlayer) {
        //debugPrint("playbackDidEnd")
        playerControls.bottomBar.playOrPauseButton.isSelected = false
        netSpeed.stop()
    }
    
    /// 开始缓冲
    public func playbackStartBuffering(player: LCPlayer) {
        //debugPrint("playbackStartBuffering")
        playerControls.startLoading()
    }
    
    /// 缓冲的进度
    public func playbackLoadedTimeRanges(player: LCPlayer, progress: CGFloat) {
        //debugPrint("playbackLoadedTimeRanges")
        playerControls.bottomBar.progressView.bufferProgress = progress
    }
    
    /// 缓存完毕
    public func playbackEndBuffering(player: LCPlayer) {
        playerControls.stopLoading()
        //debugPrint("playbackEndBuffering")
    }
    
    /// 播放错误
    public func playbackDidFailed(player: LCPlayer, error: Error) {
        //debugPrint("playbackDidFailed")
        netSpeed.stop()
        playerControls.stopLoading()
        playerControls.bottomBar.playOrPauseButton.isSelected = false
        playerControls.showError(error)
    }
}

// MARK: - NetworkSpeedMonitorProtocol ----------------------------
extension LCVideoPlayerView: NetworkSpeedMonitorProtocol {
    /// 上传速度
    /// - Parameter octets: 速度
    public func didSent(octets: UInt32) {
    }
    
    /// 下载速度
    /// - Parameter octets: 速度
    public func didReceived(octets: UInt32) {
        let speed = "加载中...\(formatSpeed(octets: octets))"
        playerControls.loadingView.speedLabel.text = speed
    }

}
