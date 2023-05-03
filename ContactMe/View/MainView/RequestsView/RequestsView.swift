//
//  RequestsView.swift
//  ContactMe
//
//  Created By Dom Montalto 01/05/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

struct RequestsView: View {
    @State private var friendRequests: [Request] = []
    @State private var users: [String: User] = [:]
    @State private var showSearchUserView = false

    var body: some View {
            NavigationView {
                Group {
                    if friendRequests.isEmpty {
                        VStack {
                            Spacer()
                            Text("No Requests")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(friendRequests) { request in
                                if let sender = users[request.senderUID] {
                                    HStack {
                                        Text("Request from \(sender.fullName)")
                                        Spacer()
                                        Button(action: {
                                            Task { await acceptFriendRequest(request) }
                                        }) {
                                            Text("Accept")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Requests")
                .background(
                    NavigationLink(destination: SearchUserView(), isActive: $showSearchUserView) {
                        EmptyView()
                    }
                )
                .navigationBarItems(trailing:
                    Button(action: {
                        showSearchUserView = true
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                )
                .onAppear {
                    Task { await fetchFriendRequests() }
                }
            }
        }


    
    func fetchFriendRequests() async {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }

        do {
            let documents = try await Firestore.firestore().collection("FriendRequests")
                .whereField("receiverUID", isEqualTo: currentUserUID)
                .whereField("status", isEqualTo: "pending")
                .getDocuments()

            let requests = try documents.documents.compactMap { doc -> Request? in
                try doc.data(as: Request.self)
            }

            await MainActor.run {
                friendRequests = requests
            }

            for request in requests {
                Task { await fetchUserDetails(request.senderUID) }
            }
        } catch {
            print("Error fetching friend requests: \(error)")
        }
    }

    func fetchUserDetails(_ uid: String) async {
        do {
            let document = try await Firestore.firestore().collection("Users")
                .document(uid)
                .getDocument()
            
            if let user = try? document.data(as: User.self), user != nil {
                await MainActor.run {
                    users[uid] = user
                }
            }
        } catch {
            print("Error fetching user details: \(error)")
        }
    }

    func acceptFriendRequest(_ request: Request) async {
        guard let requestID = request.id else { return }

        do {
            try await Firestore.firestore().collection("FriendRequests")
                .document(requestID)
                .updateData(["status": "accepted"])

            await MainActor.run {
                if let index = friendRequests.firstIndex(where: { $0.id == requestID }) {
                    friendRequests.remove(at: index)
                }
            }
        } catch {
            print("Error accepting friend request: \(error)")
        }
    }

}
