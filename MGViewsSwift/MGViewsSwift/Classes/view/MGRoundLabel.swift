//
//  RoundLabel.swift
//  XinjiangFutures
//
//  Created by Magical Water on 2018/9/21.
//  Copyright © 2018年 Pmb. All rights reserved.
//

import Foundation
import UIKit
import MGBaseViewSwift

@IBDesignable
open class MGRoundLabel: MGBaseView {
    
    //支持在nib直接設定元件類型
    @IBInspectable public var roundTypeNib: Int {
        get { return mRoundView?.roundTypeNib ?? MGRoundView.RoundType.rect.rawValue }
        set { mRoundView?.roundTypeNib = MGRoundView.RoundType.rect.rawValue }
    }
    
    //元件形狀類型
    public var roundType: MGRoundView.RoundType {
        get { return mRoundView?.roundType ?? MGRoundView.RoundType.rect }
        set { mRoundView?.roundType = newValue }
    }
    
    //************** 方形用 **************
    //各個角邊圓弧, 只有在形狀是方形時有用
    @IBInspectable public var radius: CGFloat {
        get { return mRoundView?.radius ?? 10 }
        set { mRoundView?.radius = newValue }
    }
    
    @IBInspectable public var topLeft: Bool {
        get { return mRoundView?.topLeft ?? true }
        set { mRoundView?.topLeft = newValue }
    }
    @IBInspectable public var bottomLeft: Bool {
        get { return mRoundView?.bottomLeft ?? true }
        set { mRoundView?.bottomLeft = newValue }
    }
    @IBInspectable public var topRight: Bool {
        get { return mRoundView?.topRight ?? true }
        set { mRoundView?.topRight = newValue }
    }
    @IBInspectable public var bottomRight: Bool {
        get { return mRoundView?.bottomRight ?? true }
        set { mRoundView?.bottomRight = newValue }
    }
    //************** 方形用 **************
    
    
    //************** 三角形用 **************
    //儲存三角形的三個點
    //點對應的代號
    //1 2 3
    //4 5 6
    //7 8 9
    
    //這邊填入 string, 在分割成陣列
    @IBInspectable public var pointString: String {
        get { return mRoundView?.pointString ?? "1,5,3" }
        set { mRoundView?.pointString = newValue }
    }
    //************** 三角形用 **************
    
    
    //虛線設置相關
    @IBInspectable public var strokeDash: Bool {
        get { return mRoundView?.strokeDash ?? false }
        set { mRoundView?.strokeDash = newValue }
    }
    
    //虛線繪製: phase表示开始绘制之前跳过多少点进行绘制，默认一般设置为0，第二张图片是设置5的实际效果图.
    
    //虛線繪製: lengths通常都包含两个数字，第一个是绘制的宽度，第二个表示跳过的宽度，也可以设置多个，第三张图是设置为三个参数的实际效果图.绘制按照先绘制，跳过，再绘制，再跳过，无限循环.
    //例如 let lengths:[CGFloat] = [10,20,10] // 绘制 跳过 无限循环</code></pre>
    
    
    @IBInspectable public var dashLength: Double {
        get { return mRoundView?.dashLength ?? 0 }
        set { mRoundView?.dashLength = newValue }
    }
    
    @IBInspectable public var dashSpace: Double {
        get { return mRoundView?.dashSpace ?? 0 }
        set { mRoundView?.dashSpace = newValue }
    }
    
    @IBInspectable public var strokeColor: UIColor {
        get { return mRoundView?.strokeColor ?? UIColor.blue }
        set { mRoundView?.strokeColor = newValue }
    }
    
    //漸變顏色的角度(目前只支持設置45的倍數角度: 0, 45, 90, 135, 180, -45, -90, -135)
    @IBInspectable public var angle: Int {
        get { return mRoundView?.angle ?? 0 }
        set { mRoundView?.angle = newValue }
    }
    
    //渲染的顏色, start center end 皆是方便快速設定, 最後組成陣列會是 [start, center, end]
    @IBInspectable public var fillColor: UIColor {
        get { return UIColor.blue }
        set {
            mRoundView?.startColor = newValue
            mRoundView?.centerColor = nil
            mRoundView?.endColor = newValue
        }
    }
    
    //渲染的顏色, start center end 皆是方便快速設定, 最後組成陣列會是 [start, center, end]
    @IBInspectable public var startColor: UIColor {
        get { return mRoundView?.startColor ?? UIColor.blue }
        set { mRoundView?.startColor = newValue }
    }
    
    @IBInspectable public var centerColor: UIColor? {
        get { return mRoundView?.centerColor }
        set { mRoundView?.centerColor = newValue }
    }
    
    @IBInspectable public var endColor: UIColor {
        get { return mRoundView?.endColor ?? UIColor.blue }
        set { mRoundView?.endColor = newValue }
    }
    
    //渲染的顏色陣列, 當此值為nil時使用 start, center ,end
    public var shapeColors: [UIColor]? {
        get { return mRoundView?.shapeColors }
        set { mRoundView?.shapeColors = newValue }
    }
    
    
    //填滿的圖片, 若設定圖片, 則上方 填滿顏色 及 漸變方向 失效
    @IBInspectable public var contentImage: UIImage?  {
        get { return mRoundView?.contentImage }
        set { mRoundView?.contentImage = newValue }
    }
    
    //stroke的寬度
    @IBInspectable public var strokeWidth: CGFloat {
        get { return mRoundView?.strokeWidth ?? 0}
        set { mRoundView?.strokeWidth = newValue }
    }
    
    //依照其餘屬性所得到的外筐 Rect
    private var strokeRect: CGRect {
        get {
            return CGRect(x: self.bounds.minX + strokeWidth/2,
                          y: self.bounds.minY + strokeWidth/2,
                          width: self.bounds.width - strokeWidth,
                          height: self.bounds.height - strokeWidth)
        }
    }
    
    @IBInspectable public var text: String {
        get { return mLabel.text ?? "" }
        set { mLabel.text = newValue }
    }
    
    @IBInspectable public var textColor: UIColor {
        get { return mLabel.textColor ?? UIColor.black }
        set { mLabel.textColor = newValue }
    }
    
    @IBInspectable public var textSize: CGFloat {
        get { return mLabel.font.pointSize }
        set { mLabel.font = mLabel.font.withSize(newValue) }
    }
    
    private var mRoundView: MGRoundView!
    private var mLabel: UILabel!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    open override func setupView() {
        addRoundView()
        addLabel()
    }
    
    private func addRoundView() {
        mRoundView = MGRoundView.init(frame: self.bounds)
        addSubview(mRoundView)
        //設置此變數, 在加入約束後才會自動更新frame
        mRoundView.translatesAutoresizingMaskIntoConstraints = false
        mRoundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mRoundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mRoundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mRoundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func addLabel() {
        mLabel = UILabel.init(frame: self.bounds)
        addSubview(mLabel)
        //設置此變數, 在加入約束後才會自動更新frame
        mLabel.translatesAutoresizingMaskIntoConstraints = false
        mLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mLabel.textAlignment = .center
    }
    
}
