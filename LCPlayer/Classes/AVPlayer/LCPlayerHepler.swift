//
//  LCPlayerHepler.swift
//  LCPlayer
//
//  Created by Long on 2023/7/11.
//

import UIKit
import Foundation
import AVFoundation

public protocol LCPlayerPlaybackDelegate: AnyObject {
    /// 资源已加载
    func playbackAssetLoaded(player: LCPlayer)
    
    /// 准备播放（可播放
    func playbackPlayerReadyToPlay(player: LCPlayer)
    
    /// 当前item准备播放（可播放
    func playbackItemReadyToPlay(player: LCPlayer, item: LCPlayerItem)
    
    /// 时间改变
    func playbackTimeDidChange(player: LCPlayer, to time: CMTime)
    
    /// 开始播放（点击 play
    func playbackDidBegin(player: LCPlayer)
    
    /// 暂停播放 （点击 pause
    func playbackDidPause(player: LCPlayer)
    
    /// 播放到结束
    func playbackDidEnd(player: LCPlayer)
    
    /// 开始缓冲
    func playbackStartBuffering(player: LCPlayer)
    
    /// 缓冲的进度
    func playbackLoadedTimeRanges(player: LCPlayer, progress: CGFloat)
    
    /// 缓存完毕
    func playbackEndBuffering(player: LCPlayer)
    
    /// 播放错误
    func playbackDidFailed(player: LCPlayer, error: Error)
}

extension LCPlayerPlaybackDelegate {
    /// 资源已加载
    func playbackAssetLoaded(player: LCPlayer) {}
    
    /// 准备播放（可播放
    func playbackPlayerReadyToPlay(player: LCPlayer) {}
    
    /// 当前item准备播放（可播放
    func playbackItemReadyToPlay(player: LCPlayer, item: LCPlayerItem) {}
    
    /// 时间改变
    func playbackTimeDidChange(player: LCPlayer, to time: CMTime) {}
    
    /// 开始播放（点击 play
    func playbackDidBegin(player: LCPlayer) {}
    
    /// 暂停播放 （点击 pause
    func playbackDidPause(player: LCPlayer) {}
    
    /// 播放到结束
    func playbackDidEnd(player: LCPlayer) {}
    
    /// 开始缓冲
    func playbackStartBuffering(player: LCPlayer) {}
    
    /// 缓冲的进度
    func playbackLoadedTimeRanges(player: LCPlayer, progress: CGFloat) {}
    
    /// 缓存完毕
    func playbackEndBuffering(player: LCPlayer) {}
    
    /// 播放错误
    func playbackDidFailed(player: LCPlayer, error: Error) {}
}

// MARK: - Error ----------------------------
// 自定义的错误
enum LCPlayerError: Error {
    case unknown // 未知错误
}

extension LCPlayerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Player遇到未知错误"
        }
    }
}

// MARK: - LCPlayerObserverKey ----------------------------
enum LCPlayerObserverKey: String, CaseIterable {
    case status = "status"
    case playbackBufferEmpty = "playbackBufferEmpty"
    case loadedTimeRanges = "loadedTimeRanges"
    case playbackLikelyToKeepUp = "playbackLikelyToKeepUp"
//    case playbackBufferFull = "playbackBufferFull"
}
