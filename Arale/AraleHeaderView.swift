//
//  AraleHeaderView.swift
//  Arale
//
//  Created by Zulwiyoza Putra on 13/11/18.
//  Copyright © 2018 Zulwiyoza Putra. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    private(set) var minHeight: CGFloat
    var maxHeight: CGFloat
    weak var dataSource: HeaderViewDataSource?
    weak var delegate: HeaderViewDelegate?
    var refreshControl: UIRefreshControl?
    private let ContentOffsetKeyPath = "contentOffset"
    
    @objc private var observableScrollView: UIScrollView? {
        get {
            if let dataSource = self.dataSource {
                return dataSource.observableScrollViewForHeaderView()
            }
            return nil
        }
    }
    
    private override init(frame: CGRect) {
        self.minHeight = 0
        self.maxHeight = 0
        super.init(frame: frame)
    }
    
    convenience init(minHeight: CGFloat) {
        self.init(frame: CGRect.zero)
        self.minHeight = minHeight
        self.maxHeight = minHeight * 1.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        guard let scrollView = observableScrollView else {
            return
        }
        scrollView.removeObserver(self, forKeyPath: ContentOffsetKeyPath, context: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let superview = newSuperview else {
            return
        }
        self.frame.origin.y = -minHeight
        self.frame.size.width = superview.frame.size.width
        self.frame.size.height = minHeight
        
        guard let scrollView = self.observableScrollView else {
            return
        }
        
        let verticalContentOffset = minHeight - getTopSafeAreaHeight()
        scrollView.contentInset.top = verticalContentOffset
        observeScrollViewContentOffset()
    }
    
    @available(iOS 11.0, *)
    private func getTopSafeAreaHeight() -> CGFloat {
        guard UIApplication.shared.windows.count != 0 else {
            return 0
        }
        let keyWindow = UIApplication.shared.windows[0]
        return keyWindow.safeAreaInsets.top
    }
    
    private func resizeFrameOnScroll(contentOffset: CGPoint) {
        if contentOffset.y <= -minHeight {
            let difference = -contentOffset.y - minHeight
            frame.size.height = minHeight + difference
            frame.origin.y = -(minHeight + difference)
            if contentOffset.y <= maxHeight + difference {
                delegate?.headerViewWillStartRefreshing()
            }
        }
    }
    
    private func observeScrollViewContentOffset() {
        guard let scrollView = observableScrollView else {
            return
        }
        scrollView.addObserver(self, forKeyPath: ContentOffsetKeyPath, options: [.new], context: nil)
    }
    
    private func animateRefreshControl() {
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.headerViewWillStartRefreshing()
        
        guard let refreshControl = self.refreshControl else {
            return
        }
        
        refreshControl.beginRefreshing()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = observableScrollView else {
            return
        }
        
        guard let keyPath = keyPath, keyPath == "contentOffset" else {
            return
        }
        
        guard let object = object as? UIScrollView, object == scrollView else {
            return
        }
        
        guard let change = change, let contentOffset = change[NSKeyValueChangeKey.newKey] as? CGPoint else {
            return
        }
        
        resizeFrameOnScroll(contentOffset: contentOffset)
    }
}
