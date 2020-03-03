//
//  ViewController.swift
//  Swit_WebView
//
//  Created by ping zhang on 2020/1/16.
//  Copyright © 2020 ping zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title =  "导航标题"
        
        addGoBtn()
    }
    
    @objc func addGoBtn() {
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 120, height: 45))
        
        btn.backgroundColor = .orange
        btn.setTitle("跳转", for: .normal)
        btn.addTarget(self, action: #selector(goWebView), for: .touchUpInside)
        
        view.addSubview(btn)
    }
    
    @objc func goWebView() {
        print("goWebView")
        self.navigationController?.pushViewController(GeneralWebViewController(requestUrl: "http://10.177.11.248:8080/#/fixed"), animated: true)
    }
}

