//
//  AraleHeaderView.swift
//  Arale
//
//  Created by Zulwiyoza Putra on 13/11/18.
//  Copyright © 2018 Zulwiyoza Putra. All rights reserved.
//

import UIKit

let ContentOffsetKeyPath = "contentOffset"

public class AraleHeaderView: UIView {
    /**
     Gettable image for HeaderView
     Settable from init method
     @return background image
     */
    open private(set) var backgroundImage: UIImage?
    
    /**
     Gettable minimum Height for HeaderView
     Settable from init method
     @return initial Height
     */
    open private(set) var minHeight: CGFloat
    
    private var maxHeight: CGFloat
    
    /**
     Gettable height for margin with top scrollView
     Settable from init method
     @return height for bottomMargin
     */
    open private(set) var bottomMargin: CGFloat
    
    /**
     Optional delegate
     @return delegate for HeaderView event
     */
    open weak var delegate: AraleHeaderViewDelegate?
    
    private weak var scrollView: UIScrollView?
    private weak var adjustableHeightAnchor: NSLayoutConstraint?
    
    private var isReachedMaxHeight: Bool
    
    /**
     Getter to calculate top safeAreaInsets
     @return 0 if window doesn't have safeAreaInstets
     */
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
        self.bottomMargin = 0
        self.isReachedMaxHeight = false
        super.init(frame: frame)
    }
    
    convenience public init(withMinHeight minHeight: CGFloat, bottomMargin: CGFloat = 0, backgroundImage: UIImage? = nil) {
        self.init(frame: CGRect.zero)
        self.minHeight = minHeight
        self.maxHeight = minHeight * 1.5
        self.bottomMargin = bottomMargin
        self.backgroundImage = backgroundImage
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        guard let scrollView = self.scrollView else {
            return
        }
        scrollView.removeObserver(self, forKeyPath: ContentOffsetKeyPath, context: nil)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = self.superview else {
            return
        }
        
        guard let scrollView = superview as? UIScrollView else {
            fatalError("HeaderView can be only sit as a subview of UIScrollView instance")
        }
        
        self.scrollView = scrollView
        
        setImageView()
        setScrollViewContentInset()
        setLayoutConstraints()
        observeScrollViewContentOffset()
        layoutIfNeeded()
    }
    
    private func resizeFrameOnScroll(withContentOffset contentOffset: CGPoint) {
        if self.window == nil {
            return
        }
        
        if contentOffset.y <= -minHeight {
            if let delegate = self.delegate {
                delegate.headerViewWillResizeFrame(headerView: self)
            }
            
            guard let adjustableHeightAnchor = self.adjustableHeightAnchor else {
                return
            }
            
            adjustableHeightAnchor.constant = -contentOffset.y - bottomMargin
            
            if let delegate = self.delegate {
                delegate.headerViewDidResizeFrame(headerView: self)
            }
            
            if contentOffset.y < -(maxHeight + bottomMargin) {
                if (!isReachedMaxHeight) {
                    isReachedMaxHeight = true
                    viewDidReachMaxHeight()
                } else {
                    isReachedMaxHeight = false
                }
            }
            
        }
    }
    
    private func viewDidReachMaxHeight() {
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.headerViewDidReachMaxHeight(headerView: self)
    }
    
    private func observeScrollViewContentOffset() {
        guard let scrollView = self.scrollView else {
            return
        }
        scrollView.addObserver(self, forKeyPath: ContentOffsetKeyPath, options: [.new], context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = self.scrollView else {
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
        
        resizeFrameOnScroll(withContentOffset: contentOffset)
    }
}

extension AraleHeaderView {
    private func setImageView() {
        guard let image = backgroundImage else {
            return
        }
        
        let imageView = UIImageView(image: image)
        self.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setScrollViewContentInset() {
        guard let scrollView = self.scrollView else {
            return
        }
        
        var topContentInset = minHeight + bottomMargin
        
        if #available(iOS 11.0, *) {
            topContentInset -= topSafeAreaHeight
        }
        
        scrollView.contentInset.top = topContentInset
    }
    
    private func setLayoutConstraints() {
        guard let scrollView = self.scrollView, scrollView == superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let adjustableHeightAnchor = self.heightAnchor.constraint(equalToConstant: self.minHeight)
        adjustableHeightAnchor.isActive = true
        self.adjustableHeightAnchor = adjustableHeightAnchor
        
        self.bottomAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -self.bottomMargin).isActive = true
        self.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
}
