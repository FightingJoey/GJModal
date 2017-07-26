## 自定义弹出视图

工作中经常会遇到弹出视图的需求，通常还会要求有一些动效，之前使用OC写代码的时候，使用的是`STModal`，现在使用`Swift`，就决定自己来写一个。目前仅仅是写了一个弹出视图的控制器，还非常的简陋，后期再来添加自定义`Alert`视图等功能。

很多地方参考了`STModal`，当然也做了一些修改和优化。

[STModal 自定义弹出视图-OC](https://github.com/zhenlintie/STModalDemo)

[GJModal 自定义弹出视图-Swift](https://github.com/Geselle-Joy/GJModal)

<!--more-->

**两种实现方式，核心代码是一样的，不同点在于：**

1. 将`GJModal`定义为单例，这种方式适用于，所有的弹出视图的弹出方式都是一样的。
2. 将`GJModalWindow`定义为单例，这种方式适用于，弹出视图有多种弹出方式。

### 效果图：
![](http://upload-images.jianshu.io/upload_images/1507703-33b46285b31dde61.gif?imageMogr2/auto-orient/strip)
### 使用方式
- 第一种实现方式

```
	GJModal.modal.isHideWhenTouchOutside = true
	GJModal.modal.show(contentView: view, animated: true)
```

- 第二种实现方式

```
	let modal = GJModal.init(isHideWhenTouchOutside: false)
	modal.show(contentView: view, animated: true)
```

### 核心代码
#### 初始化
```
	init(isHideWhenTouchOutside: Bool) {
        containerView.addSubview(bgView)
        self.isHideWhenTouchOutside = isHideWhenTouchOutside
        if isHideWhenTouchOutside {
            let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTaped))
            bgView.addGestureRecognizer(tap)
        }
        
    }
```
#### 弹出视图
```
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
```
#### 移除视图
```
	func hide(animated: Bool) -> Void {
        if contentView != nil {
            isHideAnimated = animated
            hideAnimation()
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
```
## 遇到的问题
1. 把视图添加到`window`上以后，视图的点击效果无法触发。自己感觉可能是因为点击手势的`Target`与`window`之间不存在引用关系，然后就在`GJModalWindow`里加了一个`modalsStack`的属性，用来添加`GJModal`。不知道具体原因是不是我想的这个，最终结果是实现了想要的点击效果。
2. 在做视图弹出动画的时候，本来想简单的使用`View`的`transform`属性来实现，但是发现如果你要弹出的视图是使用`Autolayout`来布局的话，弹出后会造成布局混乱的问题，所以最后采用了`CAAnimation`动画。
3. 在使用`CAAnimation`动画的时候，发现动画总是同时触发，不是我想要的一个动画结束后再执行另一个动画。然后采用了`CAAnimationGroup`来实现动画组，通过设置`Animation`的`beginTime`来控制动画的执行。

## 版本记录
- `V1.0` 仅实现了弹出视图控制器。  2017.7.24