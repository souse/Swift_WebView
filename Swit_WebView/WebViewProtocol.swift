//
//  WebViewProtocol.swift
//  Swit_WebView
//
//  Created by ping zhang on 2020/2/27.
//  Copyright © 2020 ping zhang. All rights reserved.
//

import Foundation
import WebKit

@objc protocol GzNativeHandler {
    @objc func handle(view: WKWebView, name: String, param: [AnyHashable: Any]?,
                      callback: @escaping (_ error: String?,  _ param: [AnyHashable : Any]?) ->Void)
    
    @objc var names: [String] { get }
}

// 提供webview以及回调方法代理
@objc protocol GzWebViewControlDelegate: AnyObject {
    @objc optional func networkDisabled()
    @objc optional func startLoad()
    @objc optional func showLoading()
    @objc optional func loadSuccess()
    @objc optional func loadFail(withError error: Error)
    @objc optional func notFoundPagePresent()
    @objc optional func webLoadSuccess() //h5告诉是否加载完成
    
    /// 扩展加载初始化url
    @objc optional var initializedUrl: String{get set}
}

@objc protocol GeneralWebViewControllerDelegate {
    @objc optional
    func drawedContentforHight(hight: CGFloat , width: CGFloat)
}

typealias WebViewControllerProtocol = GzWebViewControlDelegate & UIViewController
