//
//  ViewController.swift
//  GJModal
//
//  Created by Geselle-Joy on 2017/7/25.
//  Copyright © 2017年 Geselle-Joy. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func btnClicked(_ sender: Any) {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 320, height: 400))
        view.backgroundColor = UIColor.red
        
        let label = UILabel()
        label.text = "asdfasdfadsf"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.blue
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(16)
            make.top.equalTo(view).offset(16)
        }
        
        let btn = UIButton(type: .system)
        btn.setTitle("哈哈哈", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX).offset(0)
            make.centerY.equalTo(view.snp.centerY).offset(0)
        }
        

        GJModal.modal.isHideWhenTouchOutside = true
        GJModal.modal.show(contentView: view, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


