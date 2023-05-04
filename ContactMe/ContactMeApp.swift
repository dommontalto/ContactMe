//
//  ContactMeApp.swift
//  ContactMe
//
//  Created by Dom Montalto on 01/05/2023.
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
