//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Joel Storr on 29.08.23.
//

import Foundation


enum PersistanceActionType{
    case add, remove
}


enum PersistanceManager{
    static private let defaults = UserDefaults.standard
    
    enum Keys{
        static let favorites = "favorites"
    }
    
    
    static func updateWith(favorite: Follower, actionType: PersistanceActionType, completed: @escaping(GFError?) -> Void){
        retiveFavorites { result in
            switch result {
            case .success(let favorites):
                var retriveFavorites = favorites
                
                switch actionType{
                case .add:
                    
                    guard !retriveFavorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    retriveFavorites.append(favorite)
                    
                case .remove:
                    retriveFavorites.removeAll{$0.login == favorite.login}
                }
                
                completed(save(favorites: retriveFavorites))
                
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    

    static func retiveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void){
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else{
            completed(.success([]))
            return
        }
        
        do{
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        }catch{
            completed(.failure(.unableFavorites))
        }
    }
    
    static func save(favorites: [Follower]) -> GFError? {
        
        do{
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        }catch{
            return .unableFavorites
        }
    }
    
    
}




