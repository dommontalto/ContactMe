//
//  ContactsView.swift
//  ContactMe
//
//  Created By Dom Montalto 01/05/23.
//
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ContactsView: View {
    @State private var friends: [User] = []
    
    var body: some View {
        NavigationView {
            List(friends) { friend in
                NavigationLink(destination: ReusableProfileContent(user: friend)) {
                    Text(friend.username)
                        .font(.headline)
                }
            }
            .refreshable {
                await fetchFriends()
            }
            .navigationTitle("Contacts")
            .onAppear {
                if friends.isEmpty {
                    Task { await fetchFriends() }
                }
            }
        }
    }
    func fetchFriends() async {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        
        // Clear the friends array
        await MainActor.run {
            friends.removeAll()
        }
        
        do {
            let documents = try await Firestore.firestore().collection("FriendRequests")
                .whereField("receiverUID", isEqualTo: currentUserUID)
                .whereField("status", isEqualTo: "accepted")
                .getDocuments()
            
            let senderUIDs = documents.documents.compactMap { doc -> String? in
                doc.get("senderUID") as? String
            }
            
            for uid in senderUIDs {
                Task { await fetchFriendDetails(uid) }
            }
        } catch {
            print("Error fetching friends: \(error)")
        }
    }


    func fetchFriendDetails(_ uid: String) async {
        do {
            let document = try await Firestore.firestore().collection("Users")
                .document(uid)
                .getDocument()
        
            if let friend = try? document.data(as: User.self), friend != nil {
                await MainActor.run {
                    friends.append(friend)
                }
            }
        } catch {
            print("Error fetching friend details: \(error)")
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
