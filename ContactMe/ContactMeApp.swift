//
//  SocialMediaApp.swift
//  ContactMe
//
//  Created By Dom Montalto 01/05/23.
//

import SwiftUI
import Firebase

@main
struct ContactMeApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
