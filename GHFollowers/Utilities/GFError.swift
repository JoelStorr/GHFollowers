//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Joel Storr on 16.08.23.
//

import Foundation

enum GFError: String, Error{
    
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your Internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data resieved from the server was invalid, please try again."
    
    case unableFavorites = "Tere was an error favoriting this user. Pleas try again."
    case alreadyInFavorites = "You already favorited the user. You must REALLY like them!"
    
    
    
}
