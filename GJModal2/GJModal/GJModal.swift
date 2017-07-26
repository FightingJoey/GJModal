//
//  GJModal.swift
//  GJModal
//
//  Created by Geselle-Joy on 2017/7/26.
//  Copyright © 2017年 Geselle-Joy. All rights reserved.
//

import UIKit

class GJModal {
    
    deinit {
        print("GJModal 销毁")
    }

    let containerView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.clear
        return view
    }()
    let bgView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var contentView: UIView!
    
    private let window = GJModalWindow.sharedInstance
    
    var bgViewShowDuration = 0.2
    var bgViewAlpha: CGFloat = 0.6
    var isShowBgView = true
    var isHideWhenTouchOutside = true
    var isShowAnimated = true
    var isHideAnimated = true
    
    init(isHideWhenTouchOutside: Bool) {
        containerView.addSubview(bgView)
        self.isHideWhenTouchOutside = isHideWhenTouchOutside
        if isHideWhenTouchOutside {
            let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTaped))
            bgView.addGestureRecognizer(tap)
        }
        
    }
    
    func show(contentView: UIView, animated: Bool) {
        self.contentView = contentView
        containerView.addSubview(self.contentView)
        self.contentView.center = containerView.center
        
        window.modalsStack.append(self)
        window.addSubview(containerView)
        
        if isShowBgView {
            window.isHidden = false
            UIView.animate(withDuration: bgViewShowDuration, animations: {
                self.bgView.backgroundColor = UIColor.black
                self.bgView.alpha = self.bgViewAlpha
            })
        }
        isShowAnimated = animated
        showAnimation()
    }
    
    func hide(animated: Bool) -> Void {
        if contentView != nil {
            isHideAnimated = animated
            hideAnimation()
        }
    }
    
    private func showAnimation() {
        if isShowAnimated {
            let d1 = 0.2
            let d2 = 0.15
            
            let animation2 = CABasicAnimation(keyPath: "transform")
            animation2.autoreverses = true
            animation2.duration = d1
            animation2.beginTime = 0
            animation2.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(0.4, 0.4, 1))
            animation2.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1))
            
            let animation3 = CABasicAnimation(keyPath: "transform")
            animation3.autoreverses = true
            animation3.duration = d2
            animation3.beginTime = d1
            animation3.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1))
            animation3.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1))
            
            let group = CAAnimationGroup()
            group.duration = d2+d1
            group.animations = [animation2,animation3]
            self.contentView.layer.add(group, forKey: nil)
            
            UIView.animate(withDuration: bgViewShowDuration, animations: {
                self.contentView.alpha = 1
            })
            
        } else {
            UIView.animate(withDuration: bgViewShowDuration, animations: {
                self.contentView.alpha = 1
            })
        }
    }
    
    private func hideAnimation() {
        if isHideAnimated {
            let d1 = 0.2
            let d2 = 0.15
            UIView.animate(withDuration: d1, animations: {
                self.contentView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            }) { (finished) in
                UIView.animate(withDuration: d2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.contentView.alpha = 0
                    self.contentView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
                }, completion: { (finished) in
                    self.window.isHidden = true
                    self.containerView.removeFromSuperview()
                    self.window.modalsStack.removeAll()
                })
            }
        } else {
            UIView.animate(withDuration: bgViewShowDuration, animations: {
                self.contentView.alpha = 0
                self.containerView.removeFromSuperview()
                self.window.modalsStack.removeAll()
            })
        }
        
        if isShowBgView {
            UIView.animate(withDuration: bgViewShowDuration, animations: {
                self.bgView.backgroundColor = UIColor.clear
                self.bgView.alpha = 0
            })
        }
    }
    
    @objc func backgroundTaped() {
        hideAnimation()
    }
    
}

fileprivate class GJModalWindow: UIWindow {
    
    var modalsStack: Array<GJModal>! = []
    
    static let sharedInstance = GJModalWindow(frame: UIScreen.main.bounds)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.windowLevel = UIWindowLevelAlert
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
