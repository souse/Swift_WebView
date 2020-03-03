//
//  CommonWebHandle.swift
//  Swit_WebView
//
//  Created by ping zhang on 2020/3/2.
//  Copyright © 2020 ping zhang. All rights reserved.
//

import UIKit
import WebKit

class CommonWebHandle: NSObject, GzNativeHandler {
    private weak var controller: WebViewControllerProtocol?
    
    @objc init(controller: WebViewControllerProtocol) {
        self.controller = controller
    }
    
    private enum InteractionMethod: String, CaseIterable {
        case getUserInfo
        case getToken
    }
    
    var names: [String] = {
        return InteractionMethod.allCases.map({ "\($0)" })
    }()
    
    func handle(view: WKWebView, name: String, param: [AnyHashable : Any]?, callback: @escaping (String?, [AnyHashable : Any]?) -> Void) {
        guard param != nil else {
            print("返回参数为空，name：\(name)")
            return
        }
        
        guard let method = InteractionMethod(rawValue: name) else {
            print("未找到匹配的方法名")
            return
        }
        
        let bfi = BaseFunctionPImplement()
        
        switch method {
        case .getUserInfo:
            bfi.getUserInfo { callback(nil, $0) }
        case .getToken:
            callback(nil, bfi.getToken())
        }
    }
}
