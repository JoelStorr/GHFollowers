//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Joel Storr on 16.08.23.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache
    let placeholderImage = Images.placeholder
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadImage(fromUrl url: String){
        Task{
            image = await NetworkManager.shared.downloadImage(from: url) ?? placeholderImage
        }
    }
}
