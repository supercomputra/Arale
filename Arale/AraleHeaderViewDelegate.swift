//
//  AraleHeaderViewDelegate.swift
//  Arale
//
//  Created by Zulwiyoza Putra on 13/11/18.
//  Copyright © 2018 Zulwiyoza Putra. All rights reserved.
//

import Foundation

public protocol AraleHeaderViewDelegate: NSObjectProtocol {
    func headerViewWillResizeFrame(headerView: AraleHeaderView)
    func headerViewDidResizeFrame(headerView: AraleHeaderView)
    func headerViewDidReachMaxHeight(headerView: AraleHeaderView)
}

public extension AraleHeaderView {
    func headerViewWillResizeFrame(headerView: AraleHeaderView) { return }
    func headerViewDidResizeFrame(headerView: AraleHeaderView) { return }
    func headerViewDidReachMaxHeight(headerView: AraleHeaderView) { return }
}
