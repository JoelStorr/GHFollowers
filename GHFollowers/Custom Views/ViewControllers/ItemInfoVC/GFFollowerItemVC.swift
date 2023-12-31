//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Joel Storr on 23.08.23.
//

import UIKit

protocol GFFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC{
    
    weak var delegate: GFFollowerItemVCDelegate!

    
    init(user: User, delegate: GFFollowerItemVCDelegate){
        super.init(user: user)
        self.delegate = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItem()
    }
    
    
    private func configureItem(){
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(color: .systemGreen, title: "Get Followers", systhemImageName: "person.3")
    }
    
    
    override func actionButtonTapped(){
        delegate.didTapGetFollowers(for: user)
    }
}

