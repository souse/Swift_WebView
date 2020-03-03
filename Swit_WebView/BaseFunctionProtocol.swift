//
//  BaseFunctionProtocol.swift
//  Swit_WebView
//
//  Created by ping zhang on 2020/3/3.
//  Copyright © 2020 ping zhang. All rights reserved.
//

import Foundation

protocol BaseFunctionProtocol {
    func getUserInfo(_ callback: ([AnyHashable: Any]?) -> Void)
    func getToken() -> [AnyHashable: Any]
}
