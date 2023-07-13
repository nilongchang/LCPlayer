//
//  LCBasePlayerView.swift
//  LCPlayer
//
//  Created by Long on 2023/7/13.
//

import UIKit
import AVFoundation

public class LCBasePlayerView: UIView, LCPlayerPlaybackDelegate {

    lazy var player: LCPlayer = {
        let player = LCPlayer()
        player.setupPlayer()
        player.playbackDelegate = self
        return player
    }()
    
    // -----------------Public-----------------------
    /// 播放返回代理
    public weak var playbackDelegate: LCPlayerPlaybackDelegate?
    /// 是否自动播放, 默认true
    public var isAutoPlay: Bool = true
    
    // MARK: - Life Cycle ----------------------------
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init Method ----------------------------
    private func _setupUI() {
        let renderingView = LCPlayerRenderingView(with: player)
        addSubview(renderingView)
    }
    
    // MARK: - Public Method ----------------------------
    // 设置播放的item
    /// - Parameter item: player item
    public func setItem(_ item: LCPlayerItem?) {
        player.replaceCurrentItem(with: item)
        if isAutoPlay && item?.error == nil {
            play()
        }
    }
    /// 播放
    public func play() {
        player.play()
    }
    
    /// 暂停
    public func pause() {
        player.pause()
    }
    
    /// 重播
    /// - Parameter isAutoPlay: 是否自动播放
    public func rePlay(isAutoPlay: Bool = true) {
        seek(to: 0.0, isAutoPlay: isAutoPlay) { _ in }
    }
    
    /// 指定进度播放
    /// - Parameters:
    ///   - time: 播放位置
    ///   - isAutoPlay: 是否自动播放
    public func seek(to time: Double,
              isAutoPlay: Bool = true,
              completionHandler: @escaping (Bool) -> Void) {
        let toTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // 精确播放
        player.seek(to: toTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { [weak self] finished in
            if finished {
                if isAutoPlay {
                    self?.play()
                }
            }
            completionHandler(finished)
        })
    }


    // MARK: - LCPlayerPlaybackDelegate ----------------------------
    /// 资源已加载
    public func playbackAssetLoaded(player: LCPlayer) {
        playbackDelegate?.playbackAssetLoaded(player: player)
    }
    
    /// 准备播放（可播放
    public func playbackPlayerReadyToPlay(player: LCPlayer) {
        playbackDelegate?.playbackPlayerReadyToPlay(player: player)
    }
    
    /// 当前item准备播放（可播放
    public func playbackItemReadyToPlay(player: LCPlayer, item: LCPlayerItem) {
        playbackDelegate?.playbackItemReadyToPlay(player: player, item: item)
    }
    
    /// 时间改变
    public func playbackTimeDidChange(player: LCPlayer, to time: CMTime) {
        playbackDelegate?.playbackTimeDidChange(player: player, to: time)
    }
    
//    /// 开始播放（点击 play
//    func playbackDidBegin(player: LCPlayer)
    
//    /// 暂停播放 （点击 pause
//    func playbackDidPause(player: LCPlayer)
    
    /// 播放到结束
    public func playbackDidEnd(player: LCPlayer) {
        playbackDelegate?.playbackDidEnd(player: player)
    }
    
    /// 开始缓冲
    public func playbackStartBuffering(player: LCPlayer) {
        playbackDelegate?.playbackStartBuffering(player: player)
    }
    
    /// 缓冲的进度
    public func playbackLoadedTimeRanges(player: LCPlayer, progress: CGFloat) {
        playbackDelegate?.playbackLoadedTimeRanges(player: player, progress: progress)
    }
    
    /// 缓存完毕
    public func playbackEndBuffering(player: LCPlayer) {
        playbackDelegate?.playbackEndBuffering(player: player)
    }
    
    /// 播放错误
    public func playbackDidFailed(player: LCPlayer, error: Error) {
        playbackDelegate?.playbackDidFailed(player: player, error: error)
    }
}
