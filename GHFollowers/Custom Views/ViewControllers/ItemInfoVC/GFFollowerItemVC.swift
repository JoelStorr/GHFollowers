//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Joel Storr on 23.08.23.
//

import UIKit


class GFFollowerItemVC: GFItemInfoVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItem()
    }
    
    
    
    private func configureItem(){
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
