//
//  AraleHeaderView.swift
//  Arale
//
//  Created by Zulwiyoza Putra on 13/11/18.
//  Copyright © 2018 Zulwiyoza Putra. All rights reserved.
//

import UIKit


open class AraleHeaderView: UIView {
    /**
     The refreshControl associated with HeaderView
     Controlled by its scrollView
     */
    open var activityIndicatorView: UIActivityIndicatorView?
    
    /**
     Gettable image for HeaderView
     Settable from init method
     @return background image
     */
    open private(set) var backgroundImage: UIImage?
    
    /**
     RefreshControl will automatically endRefreshing after reaching refreshTimoutLimit
     The default is nil will animate infinitely
     @return refresh timeout limit if refreshControl is not nil
     */
    open var refreshTimeoutLimit: Double?
    
    /**
     Gettable minimum Height for HeaderView
     Settable from init method
     @return initial Height
     */
    open private(set) var minHeight: CGFloat
    
    /**
     Gettable maximum Height for HeaderView
     Constant to 125% of minHeight
     @return maximum Height to invoke activityIndicator
     */
    open private(set) var maxHeight: CGFloat
    
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
        self.maxHeight = minHeight * 1.25
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
        scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), context: nil)
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
        setSubviewLayoutConstraints()
        observeScrollViewContentOffset()
        layoutIfNeeded()
    }
    
    private func resizeFrameOnScroll(withContentOffset contentOffset: CGPoint) {
        if self.window == nil {
            return
        }
        
        if contentOffset.y < -(minHeight + bottomMargin) {
            if let delegate = self.delegate {
                delegate.headerViewWillResizeFrame(self)
            }
            
            guard let adjustableHeightAnchor = self.adjustableHeightAnchor else {
                return
            }
            
            adjustableHeightAnchor.constant = -contentOffset.y - bottomMargin
            
            if let delegate = self.delegate {
                delegate.headerViewDidResizeFrame(self)
            }
            
            if contentOffset.y <= -(maxHeight + bottomMargin) {
                if isReachedMaxHeight {
                    return
                }
                isReachedMaxHeight = true
                viewDidReachMaxHeight()
            } else {
                isReachedMaxHeight = false
            }
        }
    }
    
    private func handleActivityIndicatorAlpha(withContentOffset contentOffset: CGPoint) {
        if self.window == nil {
            return
        }
        
        guard let activityIndicatorView = self.activityIndicatorView else {
            return
        }
        
        if (contentOffset.y < -(minHeight + bottomMargin)) && (contentOffset.y >= -(maxHeight + bottomMargin)) {
            activityIndicatorView.isOpaque = true
            
            var denominator = (-contentOffset.y - (minHeight + bottomMargin))
            var nominator = (maxHeight + bottomMargin - minHeight)
            if #available(iOS 11.0, *) {
                denominator = -contentOffset.y - (minHeight + bottomMargin + topSafeAreaHeight)
                nominator = maxHeight + bottomMargin - minHeight - topSafeAreaHeight
            }
            
            activityIndicatorView.alpha = denominator/nominator
        }
    }
    
    private func viewDidReachMaxHeight() {
        if let delegate = self.delegate {
            delegate.headerViewDidReachMaxHeight(self)
        }
        
        guard let activityIndicatorView = self.activityIndicatorView else {
            return
        }
        
        if !activityIndicatorView.isAnimating {
            activityIndicatorView.startAnimating()
            
            if #available(iOS 10.0, *) {
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                feedbackGenerator.impactOccurred()
            }
            
            if let timoutLimit = refreshTimeoutLimit {
                DispatchQueue.main.asyncAfter(deadline: .now() + timoutLimit) {
                    activityIndicatorView.stopAnimating()
                    guard let scrollView = self.scrollView else {
                        return
                    }
                    self.handleActivityIndicatorAlpha(withContentOffset: scrollView.contentOffset)
                }
            }
            
        }
    }
    
    private func observeScrollViewContentOffset() {
        guard let scrollView = self.scrollView else {
            return
        }
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new], context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = self.scrollView else {
            return
        }
        
        guard let keyPath = keyPath, keyPath == #keyPath(UIScrollView.contentOffset) else {
            return
        }
        
        guard let object = object as? UIScrollView, object == scrollView else {
            return
        }
        
        guard let change = change, let contentOffset = change[NSKeyValueChangeKey.newKey] as? CGPoint else {
            return
        }
        
        resizeFrameOnScroll(withContentOffset: contentOffset)
        
        guard let activityIndicatorView = self.activityIndicatorView else {
            return
        }
        
        if !activityIndicatorView.isAnimating {
            handleActivityIndicatorAlpha(withContentOffset: contentOffset)
        }
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
    
    private func setSubviewLayoutConstraints() {
        guard let activityIndicatorView = self.activityIndicatorView else {
            return
        }
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidesWhenStopped = false
        self.addSubview(activityIndicatorView)
        
        let constraints = [
            activityIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: topAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
