//
//  Request.swift
//  ContactMe
//
//  Created by Dom Montalto on 01/05/2023.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Request: Identifiable, Codable {
    @DocumentID var id: String?
    var senderUID: String
    var receiverUID: String
    var status: String
}
