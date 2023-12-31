//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Joel Storr on 18.08.23.
//

import UIKit

enum UIHelper {
    static func createThreeColumnFlowLayout(in view: UIView)-> UICollectionViewFlowLayout{
        
        //Calculates the width of a cell
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let avalibleWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = avalibleWidth / 3
        
        //Builds the Layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}
