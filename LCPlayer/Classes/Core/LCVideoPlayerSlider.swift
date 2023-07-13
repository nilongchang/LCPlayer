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
            progressView.backgroundColor = trackTintColor
        }
    }
    /// 缓冲颜色
    public var bufferTintColor: UIColor = UIColor.white {
        didSet {
            bufferView.backgroundColor = trackTintColor
        }
    }
    
    /// 滑块大小
    public var thumbSize: CGSize = CGSize(width: 11, height: 11)
    
    /// 滑块图片
    public var thumbImage: UIImage? {
        didSet { thumbImageView.image = thumbImage }
    }
    
    // 回调
    public var handlerBlock: ((VideoPlayerSliderState) -> Void)?
    
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
        
    }
    
    private func updataLayout() {
        let width = bounds.width
        let height = bounds.height
        let cententY = height / 2
        
        trackView.frame = CGRect(x: 0, y: 0, width: width, height: trackHeight)
        let bufferW = width * bufferProgress
        bufferView.frame = CGRect(x: 0, y: 0, width: bufferW, height: trackHeight)
        let progressW = width * progress
        progressView.frame = CGRect(x: 0, y: 0, width: progressW, height: trackHeight)
        thumbImageView.frame = CGRect(origin: CGPoint.zero, size: thumbSize)
        
        trackView.center.y = cententY
        bufferView.center.y = cententY
        progressView.center.y = cententY
        thumbImageView.center = CGPoint(x: progressW, y: cententY)
    }
    
    func setupRadius() {
        trackView.layer.cornerRadius = trackRadius
        bufferView.layer.cornerRadius = trackRadius
        progressView.layer.cornerRadius = trackRadius
        trackView.layer.masksToBounds = true
        bufferView.layer.masksToBounds = true
        progressView.layer.masksToBounds = true
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
            debugPrint("begin taouch")
            UIView.animate(withDuration: 0.25) {
                self.thumbImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            handlerBlock?(.began(progress: progress))
            break
        case .changed:
            let specifiedPoint = pan.translation(in: self)
            let minX = thumbImageView.bounds.width * 0.5
            let maxX = bounds.width - minX
//            var rect = thumbImageView.frame
//            rect.origin.x += specifiedPoint.x
//            if rect.midX < minX {
//                rect.origin.x = 0
//            }
//            if rect.midX > maxX {
//                rect.origin.x = maxX - minX
//            }
            progress = specifiedPoint.x / bounds.width
            debugPrint("value = \(progress)")
            handlerBlock?(.changed(progress: progress))
            break
        case .ended:
//            thumbViewFrame = .zero
            UIView.animate(withDuration: 0.25) {
                self.thumbImageView.transform = .identity
            }
            handlerBlock?(.ended(progress: progress))
            break
        case .cancelled,.failed:
            handlerBlock?(.cancel)
            break
        default:
            break
        }
    }
}