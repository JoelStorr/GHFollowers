//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Joel Storr on 03.09.23.
//

import UIKit




extension UIView{
    func addSubViews(_ views: UIView...){
        for view in views {addSubview(view)}
    }
}

