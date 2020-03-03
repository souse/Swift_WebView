//
//  BaseFunctionPImplement.swift
//  Swit_WebView
//
//  Created by ping zhang on 2020/3/3.
//  Copyright © 2020 ping zhang. All rights reserved.
//

import Foundation

class BaseFunctionPImplement: BaseFunctionProtocol {
    func getToken() -> [AnyHashable: Any] {
        return ["token": "1010101100"]
    }
    
//    func getUserInfo() -> Dictionary<String, String> {
//        let userInfo: [String: String] = ["name": "张三", "age": "15"]
//
//        return userInfo
//    }
    
    func getUserInfo(_ fn: ([AnyHashable : Any]?) -> Void) {
        let userInfo = ["name": "张三", "age": "15"]
        
        fn(userInfo)
    }
}
