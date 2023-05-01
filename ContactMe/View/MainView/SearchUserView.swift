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
    /// - View Properties
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            ForEach(fetchedUsers) { user in
                HStack {
                    NavigationLink {
                        ReusableProfileContent(user: user)
                    } label: {
                        Text(user.username)
                            .font(.callout)
                            .hAlign(.leading)
                    }
                    Spacer()
                    Button(action: {
                        Task { await sendFriendRequest(to: user) }
                    }) {
                        Text("Send Request")
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search User")
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            /// - Fetch User From Firebase
            Task { await searchUsers() }
        })
        .onChange(of: searchText, perform: { newValue in
            if newValue.isEmpty {
                fetchedUsers = []
            }
        })
    }

    func searchUsers() async {
        do {
            let documents = try await Firestore.firestore().collection("Users")
                .whereField("username", isGreaterThanOrEqualTo: searchText)
                .whereField("username", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .limit(to: 10)
                .getDocuments()

            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
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
}

struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
    }
}
