//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Joel Storr on 23.08.23.
//

import UIKit


class GFRepoItemVC: GFItemInfoVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItem()
    }
    
    
    
    private func configureItem(){
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
}
