//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Joel Storr on 16.08.23.
//

import Foundation

class NetworkManager{
    
    static let shared = NetworkManager()
    let baseUrl = "https://api.github.com/users/"
    
    private init(){}
    
    
    func getFollowers(for username: String, page: Int, completed: @escaping([Follower]?, ErrorMessage?)->Void){
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
        
        guard let url = URL(string: endpoint) else {
            completed(nil, .inavlidUsername)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            
            if let _ = error{
                completed(nil, .unableToComplete)
            }
            
            
            guard let respnse = response as? HTTPURLResponse, respnse.statusCode == 200 else {
                completed(nil, .invalidResponse)
                return
            }
            
            guard let data = data else {
                completed(nil, .invalidResponse)
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            }catch{
                completed(nil, .invalidData)
            }
            
            
            
        }
        
        task.resume()
        
    }
    
}
