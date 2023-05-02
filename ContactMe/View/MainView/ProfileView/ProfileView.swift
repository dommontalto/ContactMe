////
//  ProfileView.swift
//  SocialMedia
//
//  Created by Balaji on 14/12/22.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct ProfileView: View {
    // MARK: My Profile Data
    @State private var myProfile: User?
    // MARK: User Defaults Data
    @AppStorage("user_profile_url") var userProfileURL: URL?
    @AppStorage("user_name") var userName: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("log_status") var logStatus: Bool = false
    // MARK: View Properties
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    
    // Add @State to manage popover presentation
    @State private var showEditPopover: Bool = false
    // Add @State to manage the edited user
    @State private var editedUser: User = User(id: nil, username: "", location: "", userBioLink: "", userUID: "", userEmail: "", userProfileURL: URL(string: "https://example.com")!)
    
    var body: some View {
        NavigationStack {
            VStack {
                if let myProfile {
                    ReusableProfileContent(user: myProfile)
                        .refreshable {
                            // MARK: Refresh User Data
                            self.myProfile = nil
                            await fetchUserData()
                        }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Edit", action: {
                        showEditPopover.toggle()
                    })
                    .popover(isPresented: $showEditPopover) {
                        VStack {
                            TextField("Username", text: $editedUser.username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Location", text: $editedUser.location)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Confirm", action: {
                                saveChanges()
                                showEditPopover.toggle()
                            })
                            .padding(.top)
                        }
                        .padding()
                        .onAppear {
                            guard let myProfile else { return }
                            editedUser = myProfile
                        }
                    }
                }
            }
        }
        .overlay {
            LoadingView(show: $isLoading)
        }
        .alert(errorMessage, isPresented: $showError) {
        }
        .task {
            // This Modifier is like onAppear
            // So Fetching for the First Time Only
            if myProfile != nil { return }
            // MARK: Initial Fetch
            await fetchUserData()
        }
    }
    
    // MARK: Fetching User Data
    func fetchUserData() async {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else { return }
        await MainActor.run(body: {
            myProfile = user
        })
    }
    
    // MARK: Logging User Out
    func logOutUser() {
        try? Auth.auth().signOut()
        userUID = ""
        userName = ""
        userProfileURL = nil
        logStatus = false
    }
    // MARK: Deleting User Entire Account
    func deleteAccount() {
        isLoading = true
        Task {
            do {
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                // Step 1: First Deleting Profile Image From Storage
                let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                try await reference.delete()
                // Step 2: Deleting Firestore User Document
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                // Final Step: Deleting Auth Account and Setting Log Status to False
                try await Auth.auth().currentUser?.delete()
                logStatus = false
            } catch {
                await setError(error)
            }
        }
    }
    
    // MARK: Setting Error
    func setError(_ error: Error) async {
        // MARK: UI Must be run on Main Thread
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
    func saveChanges() {
        guard let myProfile = myProfile else { return }
        let userRef = Firestore.firestore().collection("Users").document(myProfile.userUID)
        do {
            try userRef.setData(from: editedUser)
            self.myProfile = editedUser
        } catch {
            // await setError(error)
        }
    }
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
