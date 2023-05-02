//
//  User.swift
//  SocialMedia
//
//  Created by Balaji on 07/12/22.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable,Codable {
    @DocumentID var id: String?
    var username: String
    var location: String
    var userBioLink: String
    var userUID: String
    var userEmail: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case username
        case location
        case userBioLink
        case userUID
        case userEmail
        case userProfileURL
    }
}
