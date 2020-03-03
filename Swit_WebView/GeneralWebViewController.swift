//
//  GeneralWebViewController.swift
//  Swit_WebView
//
//  Created by ping zhang on 2020/1/17.
//  Copyright © 2020 ping zhang. All rights reserved.
//

import UIKit
import WebKit

@objcMembers class GeneralWebViewController: UIViewController {
    
    private var isWebViewLoaded: Bool = false

    var webView: WKWebView?
    var webViewControl: GzWebViewControl!
    var requestUrl: String = ""
    var navigationTitle: String?
    var callBackValueHandle: ((Any) -> Void)?
    weak var delegate: GeneralWebViewControllerDelegate?
    
    convenience init(requestUrl: String) {
        self.init(requestUrl: requestUrl, navigationTitle: nil)
    }
    
    init(requestUrl: String, navigationTitle: String?) {
        super.init(nibName: nil, bundle: nil)
        
        self.webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.requestUrl = requestUrl
        self.navigationTitle = navigationTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = navigationTitle
        webViewControl = GzWebViewControl(webView: self.webView!, delegate: self)
        
//        view.addSubview(webView!)
//        webView?.frame = self.view.frame
        view = webView!
        webViewControl.callBackValueHandle = callBackValueHandle
        configureWebView()
        loadRequest()
    }
    
    func loadRequest() {
        guard let url = URL(string: requestUrl) else {
            assert(false, "url无效")
            return
        }
        
        webView!.load(URLRequest(url: url))
    }
    
    private func configureWebView() {
        webView?.scrollView.showsVerticalScrollIndicator = false
        webView?.allowsBackForwardNavigationGestures = true
    }
}

extension GeneralWebViewController {}

extension GeneralWebViewController: GzWebViewControlDelegate {
}
