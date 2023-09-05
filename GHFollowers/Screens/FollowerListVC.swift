//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Joel Storr on 13.08.23.
//

import UIKit

class FollowerListVC: GFDataLoadingVC {

    enum Section{
        case main
    }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page: Int = 1
    var hasMoreFollowers = true
    var isSearching: Bool = false
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    
    init(username: String){
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
        //print("View is running")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
   func configureViewController(){
       view.backgroundColor = .systemBackground
       navigationController?.isNavigationBarHidden = false
       navigationController?.navigationBar.prefersLargeTitles = true
       let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
       navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        //searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    
    
    func getFollowers(username:String, page: Int){
        showLoadingView()
        isLoadingMoreFollowers = true
        
        Task{
            
            do{
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                updateUI(with: followers)
                dismissLoadingView()
            }catch{
                if let gfError = error as? GFError{
                    presentGFAlert(title: "Bad stuff happend", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultErorr()
                }
                dismissLoadingView()
            }
            
            /*
            //Alternative option if we don't need to shwo a specific error
            guard let followers = try? await NetworkManager.shared.getFollowers(for: username, page: page) else{
                presentDefaultErorr()
                return
            }
            
            updateUI(with: followers)
            dismissLoadingView()
            */
        }
        
        //------------------------------------------------------Old way--------------------------------------------------------------
        /*
         Old way of handeling Network data
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }

            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                self.updateUI(with: followers)
               
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff happend", message: error.rawValue, buttonTitle: "Ok")
            }
            self.isLoadingMoreFollowers = false
        }
         */
            /*
             Even older way of handling the Network Data
            guard let followers = followers else {
                self.presentGFAlertOnMainThread(title: "Bad stuff happend", message: errorMessage!.rawValue, buttonTitle: "Ok")
                return
            }
            
            print("Followers.count = \(followers.count)")
            print(followers)
            */
        //------------------------------------------------------Old way end --------------------------------------------------------------

    }
    
    
    func updateUI(with followers: [Follower]){
        if followers.count < 100{
            self.hasMoreFollowers = false
        }
        
        self.followers.append(contentsOf: followers)
        
        //Checks if the array is empty, if there are no followers in the array
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😀."
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message, in: self.view)
                return
            }
        }
        
        self.updateData(on: self.followers)
    }
    
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    
    //Creates a new Snapshot of Data to compare against
    func updateData(on followers:  [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    //Add user to favorite
    @objc func addButtonTapped(){
        showLoadingView()
        Task{
            do{
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                addUserToFavorites(user: user)
                dismissLoadingView()
            }catch{
                if let gfError = error as? GFError{
                    presentGFAlert(title: "Something went wrong", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultErorr()
                }
                dismissLoadingView()
            }
        }
    }
    
    func addUserToFavorites(user: User){
        //Get user infos
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        //save user infos
        PersistanceManager.updateWith(favorite: favorite, actionType: .add) {[weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Success", message: "You added the uswer to your favorites list", buttonTitle: "OK")
                }
                return
            }
            DispatchQueue.main.async {
                self.presentGFAlert(title: "Something went wront", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
}


//Extension for Pagination
extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height{
            guard hasMoreFollowers, !isLoadingMoreFollowers else{ return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        
        present(navController, animated: true)
    }
}


//Search Extension
extension FollowerListVC: UISearchResultsUpdating /*, UISearchBarDelegate*/{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else{
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter{$0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filteredFollowers)
    }
    
    //Filter check gets perfomed even if the Cancle Button is clicked
    // This is not needed
    /*
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            isSearching = false
            updateData(on: followers)
        }
    */
}

//Follower List extention
extension FollowerListVC: UserInfoVCDelegate{
    func didRequestFollowers(for username: String) {
        //get followers for the user
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
