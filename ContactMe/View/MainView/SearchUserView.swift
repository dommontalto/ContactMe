//
//  SearchUserView.swift
//  ContactMe
//
//  Created By Dom Montalto 01/05/23.
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
                    Text(user.fullName ?? "")
                        .font(.callout)
                        .hAlign(.leading)
                    
                    Text(user.userPIN ?? "" )
                        .font(.callout)
                        .hAlign(.leading)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    switch friendRequests[user.userUID ?? ""] {
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
                .disabled(friendRequests[user.userUID ?? ""] != nil)
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Add New Contact")
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
            // Query for 'fullName'
            let fullNameDocuments = try await Firestore.firestore().collection("Users")
                .whereField("fullName", isGreaterThanOrEqualTo: searchText)
                .whereField("fullName", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .limit(to: 10)
                .getDocuments()

            // Query for 'userPIN'
            let userPINDocuments = try await Firestore.firestore().collection("Users")
                .whereField("userPIN", isGreaterThanOrEqualTo: searchText)
                .whereField("userPIN", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .limit(to: 10)
                .getDocuments()

            // Merge the results of both queries
            let allDocuments = fullNameDocuments.documents + userPINDocuments.documents

            let users = try allDocuments.compactMap { doc -> User? in
                let user = try doc.data(as: User.self)
                return user.userUID != currentUserUID ? user : nil
            }
            .unique() // Remove duplicates

            await MainActor.run(body: {
                fetchedUsers = users
            })
        } catch {
            print(error.localizedDescription)
        }
    }



    func sendFriendRequest(to user: User) async {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }

        let friendRequest = Request(senderUID: currentUserUID, receiverUID: user.userUID ?? "", status: "pending")
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

extension Array where Element: Hashable {
    func unique() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
