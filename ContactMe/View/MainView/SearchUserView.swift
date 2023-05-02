//
//  SearchUserView.swift
//  SocialMedia
//
//  Created by Balaji on 27/12/22.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SearchUserView: View {
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var friendRequests: [String: String] = [:]

    var body: some View {
        List {
            ForEach(fetchedUsers) { user in
                HStack {
                    Text(user.userPIN)
                        .font(.callout)
                        .hAlign(.leading)
                    
                    Spacer()
                    
                    switch friendRequests[user.userUID] {
                    case "pending":
                        Text("Requested")
                            .foregroundColor(.gray)
                    case "accepted":
                        Text("Accepted")
                            .foregroundColor(.gray)
                    default:
                        Button(action: {
                            Task { await sendFriendRequest(to: user) }
                        }) {
                            Text("Send Request")
                        }
                    }
                }
                .disabled(friendRequests[user.userUID] != nil)
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search User")
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            Task { await searchUsers() }
        })
        .onChange(of: searchText, perform: { newValue in
            if newValue.isEmpty {
                fetchedUsers = []
            }
        })
        .onAppear {
            Task { await fetchFriendRequests() }
        }
    }


    func searchUsers() async {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }

        do {
            let documents = try await Firestore.firestore().collection("Users")
                .whereField("username", isGreaterThanOrEqualTo: searchText)
                .whereField("username", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .limit(to: 10)
                .getDocuments()

            let users = try documents.documents.compactMap { doc -> User? in
                let user = try doc.data(as: User.self)
                return user.userUID != currentUserUID ? user : nil
            }

            await MainActor.run(body: {
                fetchedUsers = users
            })
        } catch {
            print(error.localizedDescription)
        }
    }


    func sendFriendRequest(to user: User) async {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }

        let friendRequest = Request(senderUID: currentUserUID, receiverUID: user.userUID, status: "pending")
        do {
            let _ = try await Firestore.firestore().collection("FriendRequests").addDocument(from: friendRequest)
        } catch {
            print("Error sending friend request: \(error)")
        }
    }
    
    func fetchFriendRequests() async {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }

        do {
            let sentDocuments = try await Firestore.firestore().collection("FriendRequests")
                .whereField("senderUID", isEqualTo: currentUserUID)
                .getDocuments()

            let receivedDocuments = try await Firestore.firestore().collection("FriendRequests")
                .whereField("receiverUID", isEqualTo: currentUserUID)
                .getDocuments()

            let sentRequests = try sentDocuments.documents.compactMap { doc -> Request? in
                try doc.data(as: Request.self)
            }
            
            let receivedRequests = try receivedDocuments.documents.compactMap { doc -> Request? in
                try doc.data(as: Request.self)
            }

            let allRequests = sentRequests + receivedRequests

            await MainActor.run {
                for request in allRequests {
                    if request.senderUID == currentUserUID {
                        friendRequests[request.receiverUID] = request.status
                    } else {
                        friendRequests[request.senderUID] = request.status
                    }
                }
            }
        } catch {
            print("Error fetching friend requests: \(error)")
        }
    }

}

struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
    }
}
