//
//  LCPlayerLoadingView.swift
//  LCPlayer
//
//  Created by Long on 2023/7/17.
//

import UIKit

public class LCPlayerLoadingView: UIView {

    
    public lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .white)
        view.startAnimating()
        return view
    }()
    
    /// 网速
    public lazy var speedLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "加载."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Life Cycle ----------------------------
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        indicatorView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        speedLabel.frame = CGRect(x: 0, y: bounds.height - 20, width: bounds.width, height: 20)
        indicatorView.center.x = bounds.width / 2
    }
    // MARK: - Init Method ----------------------------
    private func setupUI() {
        
        addSubview(indicatorView)
        addSubview(speedLabel)
        
    }
}
