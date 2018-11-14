//
//  AraleHeaderView.swift
//  Arale
//
//  Created by Zulwiyoza Putra on 13/11/18.
//  Copyright © 2018 Zulwiyoza Putra. All rights reserved.
//

import UIKit

let ContentOffsetKeyPath = "contentOffset"

public class HeaderView: UIView {
    public var minHeight: CGFloat
    public var maxHeight: CGFloat
    public var refreshControl: UIRefreshControl?
    
    public weak var dataSource: HeaderViewDataSource?
    public weak var delegate: HeaderViewDelegate?
    
    private var observableScrollView: UIScrollView? {
        get {
            if let dataSource = self.dataSource {
                return dataSource.observableScrollViewForHeaderView()
            }
            return nil
        }
    }
    
    public var bottomMargin: CGFloat
    
    @available(iOS 11.0, *)
    private var topSafeAreaHeight: CGFloat {
        get {
            guard UIApplication.shared.windows.count != 0 else {
                return 0
            }
            let keyWindow = UIApplication.shared.windows[0]
            return keyWindow.safeAreaInsets.top
        }
    }
    
    private override init(frame: CGRect) {
        self.minHeight = 0
        self.maxHeight = 0
        self.bottomMargin = 16
        super.init(frame: frame)
    }
    
    convenience public init(minHeight: CGFloat) {
        self.init(frame: CGRect.zero)
        self.minHeight = minHeight
        self.maxHeight = minHeight * 1.5
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        guard let scrollView = observableScrollView else {
            return
        }
        scrollView.removeObserver(self, forKeyPath: ContentOffsetKeyPath, context: nil)
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let superview = newSuperview else {
            return
        }
        
        self.frame.origin.y = -minHeight
        self.frame.size.width = superview.frame.size.width
        self.frame.size.height = minHeight
        
        setScrollViewContentInset()
        observeScrollViewContentOffset()
    }
    
    private func setScrollViewContentInset() {
        guard let scrollView = self.observableScrollView else {
            return
        }
        
        var topContentInset = minHeight + bottomMargin
        
        if #available(iOS 11.0, *) {
            topContentInset -= topSafeAreaHeight
        }
        
        scrollView.contentInset.top = topContentInset
    }
    
    private func resizeFrameOnScroll(contentOffset: CGPoint) {
        if contentOffset.y <= -minHeight {
            let difference = -contentOffset.y - minHeight - bottomMargin
            frame.size.height = minHeight + difference
            frame.origin.y = -(minHeight + difference + bottomMargin)
            
            if contentOffset.y <= maxHeight + difference {
                animateRefreshControl()
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
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = observableScrollView else {
            return
        }
        
        guard let keyPath = keyPath, keyPath == ContentOffsetKeyPath else {
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
