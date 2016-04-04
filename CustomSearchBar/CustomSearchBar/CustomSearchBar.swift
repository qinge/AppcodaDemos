//
//  CustomSearchBar.swift
//  CustomSearchBar
//
//  Created by qinge on 16/3/20.
//  Copyright © 2016年 Appcoda. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    var preferredFont: UIFont!
    var preferredTextColor: UIColor!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        searchBarStyle = UISearchBarStyle.Prominent
        translucent = false
        
    }
    
    func indexOfSearchFieldInSubviews() -> Int!{
        var index: Int!
        let searchBarView = subviews[0]
        
        for var i = 0; i < searchBarView.subviews.count; ++i {
            if searchBarView.subviews[i].isKindOfClass(UITextField) {
                index = i
                break
            }
        }
        return index
    }


    override func drawRect(rect: CGRect) {
        if let index = indexOfSearchFieldInSubviews() {
            let searchField: UITextField = subviews[0].subviews[index] as! UITextField
            searchField.frame = CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10)
            
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            
            searchField.backgroundColor = barTintColor
        }
        
        // 画搜索栏下面的横线
        let startPoint = CGPointMake(0.0, frame.size.height)
        let endPoint = CGPointMake(frame.size.width, frame.size.height)
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addLineToPoint(endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.strokeColor = preferredTextColor.CGColor
        
        layer.addSublayer(shapeLayer)
        
        
        super.drawRect(rect)
    }

}
