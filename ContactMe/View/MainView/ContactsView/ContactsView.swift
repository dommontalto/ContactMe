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
    @State private var contacts: [User] = []
    @State private var isRefreshing: Bool = false

    var body: some View {
           NavigationView {
               if contacts.isEmpty {
                   ZStack {
                       if !isRefreshing {
                           VStack {
                               Spacer()
                               Text("No Contacts")
                                   .font(.largeTitle)
                                   .foregroundColor(.gray)
                               Spacer()
                           }
                       } else {
                           ProgressView()
                               .progressViewStyle(CircularProgressViewStyle())
                       }
                   }
                   .navigationTitle("Contacts")
                   .navigationBarTitleDisplayMode(.inline)
                   .onAppear {
                       if contacts.isEmpty {
                           Task { await fetchFriends() }
                       }
                   }
               } else {
                List(sortedContacts()) { friend in
                    NavigationLink(destination:
                        VStack {
                            ReusableProfileContent(user: friend)
                            .offset(y: -20)
                        }
                       
                    ) {
                        Text(friend.fullName ?? "")
                            .font(.headline)
                    }
                }
                .refreshable {
                    isRefreshing = true
                    await fetchFriends()
                    isRefreshing = false
                }
                .navigationTitle("Contacts")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    if contacts.isEmpty {
                        Task { await fetchFriends() }
                    }
                }
            }
        }
    }

    func sortedContacts() -> [User] {
        return contacts.sorted(by: { ($0.fullName ?? "") < ($1.fullName ?? "") })
    }

    func fetchFriends() async {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        
        // Clear the friends array
        await MainActor.run {
            contacts.removeAll()
        }
        
        do {
            let senderDocuments = try await Firestore.firestore().collection("FriendRequests")
                .whereField("receiverUID", isEqualTo: currentUserUID)
                .whereField("status", isEqualTo: "accepted")
                .getDocuments()
            
            let receiverDocuments = try await Firestore.firestore().collection("FriendRequests")
                .whereField("senderUID", isEqualTo: currentUserUID)
                .whereField("status", isEqualTo: "accepted")
                .getDocuments()
            
            let senderUIDs = senderDocuments.documents.compactMap { doc -> String? in
                doc.get("senderUID") as? String
            }
            
            let receiverUIDs = receiverDocuments.documents.compactMap { doc -> String? in
                doc.get("receiverUID") as? String
            }
            
            let allUIDs = Array(Set(senderUIDs + receiverUIDs))
            
            for uid in allUIDs {
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
                    // Only append the friend if they are not already in the contacts array
                    if !contacts.contains(where: { $0.id == friend.id }) {
                        contacts.append(friend)
                    }
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
