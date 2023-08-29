//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Joel Storr on 29.08.23.
//

import Foundation


enum PersistanceManager{
    static private let defaults = UserDefaults.standard
    
    enum Keys{
        static let favorites = "favorites"
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




