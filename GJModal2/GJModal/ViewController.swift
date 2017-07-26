//
//  ViewController.swift
//  GJModal
//
//  Created by Geselle-Joy on 2017/7/26.
//  Copyright © 2017年 Geselle-Joy. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func btnClicked(_ sender: Any) {
        
        let modal = GJModal.init(isHideWhenTouchOutside: false)
        
        let view = TestView(frame: CGRect.init(x: 0, y: 0, width: 320, height: 400))
        // 之所以这么写，是因为闭包强引用了modal，不这么写无法销毁
        weak var weakmodal = modal
        view.block = {
            weakmodal?.hide(animated: true)
        }
        modal.show(contentView: view, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

