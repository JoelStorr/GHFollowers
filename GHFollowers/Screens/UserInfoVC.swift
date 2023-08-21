//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Joel Storr on 19.08.23.
//

import UIKit

class UserInfoVC: UIViewController {
    
    
    var username : String!
    
    let headerView = UIView()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        NetworkManager.shared.getUserInfo(for: username) {[weak self] result in
            guard let self = self else { return }
            
            switch result{
            case .success(let user):
                print(user)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong.", message: error.rawValue, buttonTitle: "OK")
            }
        }
        
        layoutUI()
        
    }
    
    
    func layoutUI(){
        view.addSubview(headerView)
        headerView.backgroundColor = .systemPink
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        
        ])
    }
    
    
    
    
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
   

}
