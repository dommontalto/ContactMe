//
//  MainView.swift
//  SocialMedia
//
//  Created by Balaji on 14/12/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        // MARK: TabView With Recent Post's And Profile Tabs
        TabView {
            ContactsView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Contacts")
                }
            
            RequestsView()
                .tabItem {
                    Image(systemName: "person.badge.plus.fill")
                    Text("Requests")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        // Changing Tab Lable Tint to Black
        .tint(.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
