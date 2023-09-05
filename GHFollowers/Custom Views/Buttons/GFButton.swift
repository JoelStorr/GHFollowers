//
//  GFButton.swift
//  GHFollowers
//
//  Created by Joel Storr on 12.08.23.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    //Handles Inits via Stroyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(color: UIColor, title: String, systhemImageName: String){
        self.init(frame: .zero)
        set(color: color, title: title, systhemImageName: systhemImageName)
    }
    
    
    private func configure(){
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func set (color: UIColor, title: String, systhemImageName: String){
        
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title
        
        
        configuration?.image = UIImage(systemName: systhemImageName)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
        
        
    }
}
