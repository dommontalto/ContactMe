//
//  ContactsView.swift
//  ContactMe
//
//  Created By Dom Montalto 01/05/23.
//

import SwiftUI

struct ContactsView: View {
    @State private var contacts: [String] = ["Alice", "Bob", "Charlie", "David"]
    
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
            .navigationTitle("Contacts")
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
