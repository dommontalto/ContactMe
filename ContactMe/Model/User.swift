//
//  User.swift
//  SocialMedia
//
//  Created by Balaji on 07/12/22.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable,Codable,Hashable {
    @DocumentID var id: String?
    var fullName: String
    var userPIN: String
    var location: String
    var userUID: String
    var userEmail: String
    var userProfileURL: URL
    var mobile: String?
    var twitter: String?
    var instagram: String?
    var telegram: String?
    
    enum CodingKeys: CodingKey {
        case id
        case fullName
        case userPIN
        case location
        case userUID
        case userEmail
        case userProfileURL
        case mobile
        case twitter
        case instagram
        case telegram
        
    }
}
