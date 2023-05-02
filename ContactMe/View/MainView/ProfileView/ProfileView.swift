//
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
    @AppStorage("user_profile_url") var profileURL: URL?
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
    @State private var editedUser: User?
    
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
                        editedUser = myProfile
                        showEditPopover.toggle()
                    })
                    .popover(isPresented: $showEditPopover) {
                        VStack {
                            TextField("Username", text: Binding(get: { editedUser?.username ?? "" }, set: { editedUser?.username = $0 }))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("User Bio", text: Binding(get: { editedUser?.userBio ?? "" }, set: { editedUser?.userBio = $0 }))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("User Bio Link", text: Binding(get: { editedUser?.userBioLink ?? "" }, set: { editedUser?.userBioLink = $0 }))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("User Email", text: Binding(get: { editedUser?.userEmail ?? "" }, set: { editedUser?.userEmail = $0 }))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Confirm", action: {
                                saveChanges()
                                showEditPopover.toggle()
                            })
                            .padding(.top)
                        }
                        .padding()
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
            // This Modifer is like onAppear
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
        profileURL = nil
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
        guard let updatedUser = editedUser else { return }
        let userRef = Firestore.firestore().collection("Users").document(updatedUser.userUID)
        do {
            try userRef.setData(from: updatedUser)
            myProfile = updatedUser
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
