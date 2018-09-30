//
//  AlignmentImageViewMask.swift
//  XinjiangFutures
//
//  Created by Magical Water on 2018/9/26.
//  Copyright © 2018年 Pmb. All rights reserved.
//

import UIKit

public struct MGAlignmentImageViewMask: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    
    public static let center = MGAlignmentImageViewMask(rawValue: 0)
    public static let left = MGAlignmentImageViewMask(rawValue: 1)
    public static let right = MGAlignmentImageViewMask(rawValue: 2)
    public static let top = MGAlignmentImageViewMask(rawValue: 4)
    public static let bottom = MGAlignmentImageViewMask(rawValue: 8)
    public static let topLeft: MGAlignmentImageViewMask = [top, left]
    public static let topRight: MGAlignmentImageViewMask = [top, right]
    public static let bottomLeft: MGAlignmentImageViewMask = [bottom, left]
    public static let bottomRight: MGAlignmentImageViewMask = [bottom, right]
}

@IBDesignable
open class MGAlignmentImageView: UIImageView {
    
    open var alignment: MGAlignmentImageViewMask = .center {
        didSet {
            guard alignment != oldValue else { return }
            updateLayout()
        }
    }
    
    open override var image: UIImage? {
        set {
            realImageView?.image = newValue
            setNeedsLayout()
        }
        get {
            return realImageView?.image
        }
    }
    
    open override var highlightedImage: UIImage? {
        set {
            realImageView?.highlightedImage = newValue
            setNeedsLayout()
        }
        get {
            return realImageView?.highlightedImage
        }
    }
    
    @IBInspectable open var alignTop: Bool {
        set {
            setInspectableProperty(newValue, alignment: .top)
        }
        get {
            return getInspectableProperty(.top)
        }
    }
    
    @IBInspectable open var alignLeft: Bool {
        set {
            setInspectableProperty(newValue, alignment: .left)
        }
        get {
            return getInspectableProperty(.left)
        }
    }
    
    @IBInspectable open var alignRight: Bool {
        set {
            setInspectableProperty(newValue, alignment: .right)
        }
        get {
            return getInspectableProperty(.right)
        }
    }
    
    @IBInspectable open var alignBottom: Bool {
        set {
            setInspectableProperty(newValue, alignment: .bottom)
        }
        get {
            return getInspectableProperty(.bottom)
        }
    }
    
    open override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            layer.contents = nil
        }
        get {
            return super.isHighlighted
        }
    }
    
    private(set) var realImageView: UIImageView?
    
    //    open override var bounds: CGRect {
    //        didSet {
    //            updateLayout()
    //        }
    //    }
    
    private var realContentSize: CGSize {
        var size = bounds.size
        
        guard let image = image else { return size }
        
        let scaleX = size.width / image.size.width
        let scaleY = size.height / image.size.height
        
        switch contentMode {
        case .scaleAspectFill:
            let scale = max(scaleX, scaleY)
            size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            
        case .scaleAspectFit:
            let scale = min(scaleX, scaleY)
            size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            
        case .scaleToFill:
            size = CGSize(width: image.size.width * scaleX, height: image.size.height * scaleY)
            
        default:
            size = image.size
        }
        
        return size
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        setup(image: image)
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        setup(image: image, highlightedImage: highlightedImage)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        updateLayout()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.contents = nil
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.contents = nil
        if #available(iOS 11, *) {
            let currentImage = realImageView?.image
            image = nil
            realImageView?.image = currentImage
        }
    }
    
    private func setup(image: UIImage? = nil, highlightedImage: UIImage? = nil) {
        realImageView = UIImageView(image: image ?? super.image, highlightedImage: highlightedImage ?? super.highlightedImage)
        realImageView?.frame = bounds
        realImageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        realImageView?.contentMode = contentMode
        addSubview(realImageView!)
    }
    
    private func updateLayout() {
        let realSize = realContentSize
        var realFrame = CGRect(origin: CGPoint(x: (bounds.size.width - realSize.width) / 2.0,
                                               y: (bounds.size.height - realSize.height) / 2.0),
                               size: realSize)
        
        if alignment.contains(.left) {
            realFrame.origin.x = 0.0
        } else if alignment.contains(.right) {
            realFrame.origin.x = bounds.maxX - realFrame.size.width
        }
        
        if alignment.contains(.top) {
            realFrame.origin.y = 0.0
        } else if alignment.contains(.bottom) {
            realFrame.origin.y = bounds.maxY - realFrame.size.height
        }
        
        realImageView?.frame = realFrame.integral
        
        layer.contents = nil
        if #available(iOS 11, *) {
            super.image = nil
        }
    }
    
    private func setInspectableProperty(_ newValue: Bool, alignment: MGAlignmentImageViewMask) {
        if newValue {
            self.alignment.insert(alignment)
        } else {
            self.alignment.remove(alignment)
        }
    }
    
    private func getInspectableProperty(_ alignment: MGAlignmentImageViewMask) -> Bool {
        return self.alignment.contains(alignment)
    }
}
