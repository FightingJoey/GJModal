//
//  TestView.swift
//  GJModal
//
//  Created by Geselle-Joy on 2017/7/26.
//  Copyright © 2017年 Geselle-Joy. All rights reserved.
//

import UIKit
import SnapKit

public typealias EmptyBlock = (() -> ())

class TestView: UIView {

    var block: EmptyBlock!
    
    func hideBtnClicked() {
        if block != nil {
            block()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        
        let label = UILabel()
        label.text = "asdfasdfadsf"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.blue
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(16)
            make.top.equalTo(self).offset(16)
        }
        
        let btn = UIButton(type: .system)
        btn.setTitle("哈哈哈", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.addTarget(self, action: #selector(hideBtnClicked), for: UIControlEvents.touchUpInside)
        self.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX).offset(0)
            make.centerY.equalTo(self.snp.centerY).offset(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
