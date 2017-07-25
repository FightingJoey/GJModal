//
//  GJModal.swift
//  GJModal
//
//  Created by Geselle-Joy on 2017/7/25.
//  Copyright © 2017年 Geselle-Joy. All rights reserved.
//

import UIKit

class GJModal: NSObject {
    
    static let modal = GJModal()
    
    let window: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelAlert
        window.isOpaque = false
        window.backgroundColor = UIColor.clear
        window.isHidden = true
        return window
    }()
    
    var bgViewShowDuration = 0.2
    
    var bgViewAlpha: CGFloat = 0.6
    
    let bgView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var contentView: UIView!
    
    var isShowBgView: Bool = true
    var isHideWhenTouchOutside: Bool = true
    var isShowAnimated: Bool = true
    var isHideAnimated: Bool = true
    
    override init() {
        super.init()
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTaped))
        bgView.addGestureRecognizer(tap)
        window.addSubview(bgView)
    }
    
    public func show(contentView: UIView, animated: Bool?) -> Void {
        self.contentView = contentView
        self.contentView.alpha = 0
        self.contentView.center = bgView.center
        window.addSubview(self.contentView)
        
        if isShowBgView {
            window.isHidden = false
            UIView.animate(withDuration: bgViewShowDuration, animations: {
                self.bgView.backgroundColor = UIColor.black
                self.bgView.alpha = self.bgViewAlpha
            })
        }
        isShowAnimated = animated != nil ? animated! : true
        showAnimation()
    }
    
    public func hide(animated: Bool?) {
        if contentView != nil {
            isHideAnimated = animated != nil ? animated! : true
            hideAnimation()
        }
    }
    
    private func showAnimation() {
        if isShowAnimated {
            let d1 = 0.2
            let d2 = 0.15
            
            UIView.animate(withDuration: bgViewShowDuration, animations: {
                self.contentView.alpha = 1
            })
            
            let animation = CABasicAnimation(keyPath: "transform")
            animation.autoreverses = true
            animation.duration = 0.01
            animation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.4, 0.4, 1))
            self.contentView.layer.add(animation, forKey: nil)
            
            let animation2 = CABasicAnimation(keyPath: "transform")
            animation2.autoreverses = true
            animation2.duration = d1
//            animation2.beginTime = 0.01
            animation2.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1))
            self.contentView.layer.add(animation2, forKey: nil)
            
            
            let animation3 = CABasicAnimation(keyPath: "transform")
            animation3.autoreverses = true
            animation3.duration = d2
//            animation3.beginTime = 0.01+d1
            animation3.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1))
            self.contentView.layer.add(animation3, forKey: nil)
            
//            UIView.animate(withDuration: 2, delay: 2, options: UIViewAnimationOptions.curveEaseOut, animations: {
//                
//            }, completion: { (finished) in
//                
//                if finished {
//                    UIView.animate(withDuration: d1, animations: {
//                        
//                        
//                    }) { (finished) in
//                        UIView.animate(withDuration: d2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
//                            
//                        })
//                    }
//                }
//                
//            })
            
            
            
            
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
                    self.contentView.removeFromSuperview()
                })
            }
        } else {
            UIView.animate(withDuration: bgViewShowDuration, animations: {
                self.contentView.alpha = 0
            })
        }
        
        if isShowBgView {
            UIView.animate(withDuration: bgViewShowDuration, animations: {
                self.bgView.backgroundColor = UIColor.clear
                self.bgView.alpha = 0
            })
        }
    }
    
    @objc private func backgroundTaped() -> Void {
        if isHideWhenTouchOutside {
            hideAnimation()
        }
    }
}

