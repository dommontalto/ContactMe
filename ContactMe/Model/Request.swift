//
//  Request.swift
//  SocialMedia
//
//  Created by Dom Montalto on 3/5/2023.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Request: Identifiable, Codable {
    @DocumentID var id: String?
    var senderUID: String
    var receiverUID: String
    var status: String
}
