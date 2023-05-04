//
//  User.swift
//  ContactMe
//
//  Created By Dom Montalto 01/05/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable,Codable,Hashable {
    @DocumentID var id: String?
    var userUID: String
    var userEmail: String
    var userProfileURL: URL
    var fullName: String
    var userPIN: String
    var location: String?
    var birthday: String?
    var email: String?
    var mobile: String?
    var whatsapp: String?
    var facebook: String?
    var facebookMessenger: String?
    var twitter: String?
    var instagram: String?
    var telegram: String?
    var linkedin: String?
    var discord: String?
    var youtube: String?
    var tiktok: String?
    
    enum CodingKeys: CodingKey {
        case id
        case userUID
        case userEmail
        case userProfileURL
        case fullName
        case userPIN
        case location
        case birthday
        case email
        case mobile
        case whatsapp
        case facebook
        case facebookMessenger
        case twitter
        case instagram
        case telegram
        case linkedin
        case discord
        case youtube
    }
}
