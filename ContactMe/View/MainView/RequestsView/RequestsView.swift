//
//  RequestsView.swift
//  SocialMedia
//
//  Created by Dom Montalto on 1/5/2023.
//

import SwiftUI

struct RequestsView: View {
    @State private var contacts: [String] = ["Jack", "John"]
    
    var body: some View {
        NavigationView {
            List(contacts, id: \.self) { contact in
                Text(contact)
                    .font(.headline)
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                         SearchUserView()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .tint(.black)
                            .scaleEffect(0.9)
                    }
                }
            })
            .navigationTitle("Requests")
        }
    }
}

struct RequestsView_Previews: PreviewProvider {
    static var previews: some View {
        RequestsView()
    }
}
