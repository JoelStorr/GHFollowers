//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Joel Storr on 11.08.23.
//

import UIKit

class FavoritesListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemRed
        
        
        PersistanceManager.retiveFavorites { result in
            switch result {
            case .success(let favorites):
                print(favorites)
            case .failure(let error):
                break
            }
        }
        
    }
    

   

}
