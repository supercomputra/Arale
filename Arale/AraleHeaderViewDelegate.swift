//
//  AraleHeaderViewDelegate.swift
//  Arale
//
//  Created by Zulwiyoza Putra on 13/11/18.
//  Copyright © 2018 Zulwiyoza Putra. All rights reserved.
//

import Foundation

public protocol AraleHeaderViewDelegate: NSObjectProtocol {
    func headerViewWillResizeFrame(_ headerView: AraleHeaderView)
    func headerViewDidResizeFrame(_ headerView: AraleHeaderView)
    func headerViewDidReachMaxHeight(_ headerView: AraleHeaderView)
}

public extension AraleHeaderView {
    func headerViewWillResizeFrame(_ headerView: AraleHeaderView) { return }
    func headerViewDidResizeFrame(_ headerView: AraleHeaderView) { return }
    func headerViewDidReachMaxHeight(_headerView: AraleHeaderView) { return }
}
