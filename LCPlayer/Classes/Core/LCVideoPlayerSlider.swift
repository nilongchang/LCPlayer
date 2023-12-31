//
//  LCVideoPlayerSlider.swift
//  LCPlayer
//
//  Created by Long on 2023/7/13.
//

import UIKit

/// 滑块状态
public enum VideoPlayerSliderState {
    case began(progress: CGFloat)            // 滑动开始
    case changed(progress: CGFloat)          // 滑动改变
    case ended(progress: CGFloat)            // 滑动结束
    case onTap(progress: CGFloat)            // 点击滑杆某个位置
    case cancel                              // 取消
}

public class LCVideoPlayerSlider: UIView {
    // MARK: - Data's ----------------------------
    // 进度更新
    public var progress: CGFloat = 0.0 {
        didSet {
            updataLayout()
        }
    }
    
    // 缓存进度
    public var bufferProgress: CGFloat = 0.0 {
        didSet {
            updataLayout()
        }
    }
    
    /// 轨道高度
    public var trackHeight: CGFloat = 4
    
    /// 轨道圆角
    public var trackRadius: CGFloat = 2 {
        didSet { setupRadius() }
    }
    
    /// 轨道颜色
    public var trackTintColor: UIColor = UIColor.white {
        didSet {
            trackView.backgroundColor = trackTintColor
        }
    }
    
    /// 进度颜色
    public var progressTintColor: UIColor = UIColor.white {
        didSet {
            progressView.backgroundColor = progressTintColor
        }
    }
    
    /// 缓冲颜色
    public var bufferTintColor: UIColor = UIColor.white {
        didSet {
            bufferView.backgroundColor = bufferTintColor
        }
    }
    
    /// 滑块大小
    public var thumbSize: CGSize = CGSize(width: 12, height: 12)
    
    /// 滑块圆角
    public var thumbRadius: CGFloat = 6 {
        didSet { setupRadius() }
    }
    
    /// 滑块图片
    public var thumbImage: UIImage? {
        didSet { thumbImageView.image = thumbImage }
    }
    
    /// 回调
    public var handlerBlock: ((VideoPlayerSliderState) -> Void)?
    
    /// 拖拽前的进度
    private var beginProgress: CGFloat = 0
    
    // MARK: - UI ----------------------------
    /// 轨道
    private lazy var trackView: UIView = {
        let view = UIView()
        return view
    }()
    /// 进度
    private lazy var progressView: UIView = {
        let view = UIView()
        return view
    }()
    ///  缓冲
    private lazy var bufferView: UIView = {
        let view = UIView()
        return view
    }()
    ///  滑块
    private lazy var thumbImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Life Cycle ----------------------------
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updataLayout()
    }
    // MARK: - Private Method ----------------------------
    private func setupUI() {
        addSubview(trackView)
        addSubview(bufferView)
        addSubview(progressView)
        addSubview(thumbImageView)
        
        trackView.backgroundColor = trackTintColor
        bufferView.backgroundColor = bufferTintColor
        progressView.backgroundColor = progressTintColor
        thumbImageView.image = thumbImage
        
        setupRadius()
        
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        addGestureRecognizer(pan)
        
        thumbImageView.frame = CGRect(origin: CGPoint.zero, size: thumbSize)
    }
    
    private func updataLayout() {
        if progress.isNaN {
            progress = 0.0
            return
        }
        if bufferProgress.isNaN {
            bufferProgress = 0.0
            return
        }
        
        let width = bounds.width
        let height = bounds.height
        let cententY = height / 2
        
        trackView.frame = CGRect(x: 0, y: 0, width: width, height: trackHeight)
        let bufferW = width * bufferProgress
        bufferView.frame = CGRect(x: 0, y: 0, width: bufferW, height: trackHeight)
        let progressW = width * progress
        progressView.frame = CGRect(x: 0, y: 0, width: progressW, height: trackHeight)
        
        trackView.center.y = cententY
        bufferView.center.y = cententY
        progressView.center.y = cententY
        let minx = min(progressW, width - thumbSize.width / 2)
        let centerX = max(minx, thumbSize.width / 2)
        
        thumbImageView.center = CGPoint(x: centerX, y: cententY)
    }
    
    func setupRadius() {
        trackView.layer.cornerRadius = trackRadius
        bufferView.layer.cornerRadius = trackRadius
        progressView.layer.cornerRadius = trackRadius
        thumbImageView.layer.cornerRadius = thumbRadius
        trackView.layer.masksToBounds = true
        bufferView.layer.masksToBounds = true
        progressView.layer.masksToBounds = true
        thumbImageView.layer.masksToBounds = true
    }
    
    // MARK: - Touch Event ----------------------------
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        let contentW = bounds.width
        if contentW.isNaN {
            return
        }
        var progress = (point.x - thumbImageView.bounds.width * 0.5) / contentW
        progress = progress > 1.0 ? 1.0 : progress <= 0 ? 0 : progress
        self.progress = progress
        handlerBlock?(.onTap(progress: progress))
    }
    
    @objc func panAction(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            UIView.animate(withDuration: 0.25) {
                self.thumbImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            beginProgress = progress
            handlerBlock?(.began(progress: progress))
            break
        case .changed:
            let translationPoint = pan.translation(in: self)
            let translationProgress = translationPoint.x / bounds.width
            var newProgress = translationProgress + beginProgress
            newProgress = min(newProgress, 1)
            newProgress = max(0, newProgress)
            progress = newProgress
            handlerBlock?(.changed(progress: progress))
            break
        case .ended:
            debugPrint("ended")
            UIView.animate(withDuration: 0.25) {
                self.thumbImageView.transform = .identity
            }
            handlerBlock?(.ended(progress: progress))
            break
        case .cancelled,.failed:
            debugPrint("cancelled")
            handlerBlock?(.cancel)
            break
        default:
            break
        }
    }
}
