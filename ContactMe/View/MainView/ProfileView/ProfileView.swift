//
//  ProfileView.swift
//  ContactMe
//
//  Created By Dom Montalto 01/05/23.
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
    @State private var editedUser: User = User(id: nil, userUID: "", userEmail: "", userProfileURL: URL(string: "https://example.com")!, fullName: "", userPIN: "", location: "", birthday: "", email: "", mobile: "", whatsapp: "", facebook: "", facebookMessenger: "", twitter: "", instagram: "", telegram: "", linkedin: "", discord: "", youtube: "", tiktok: "")
    
    var body: some View {
        NavigationStack {
            VStack {
                if let myProfile = myProfile {
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
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Edit", action: {
                        showEditPopover.toggle()
                    })
                    .popover(isPresented: $showEditPopover) {
                        ScrollView{
                            VStack {
                                VStack {
                                    TextField("Full Name", text: $editedUser.fullName)
                                        .border(1, .gray.opacity(0.5))
                                        .autocapitalization(.none)
                                    
                                    TextField("Location", text: Binding<String>(
                                        get: { editedUser.location ?? "" },
                                        set: { editedUser.location = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                    TextField("Birthday", text: Binding<String>(
                                        get: { editedUser.birthday ?? "" },
                                        set: { editedUser.birthday = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                    TextField("Email", text: Binding<String>(
                                        get: { editedUser.email ?? "" },
                                        set: { editedUser.email = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                    TextField("Mobile", text: Binding<String>(
                                        get: { editedUser.mobile ?? "" },
                                        set: { editedUser.mobile = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                    TextField("Whatsapp", text: Binding<String>(
                                        get: { editedUser.whatsapp ?? "" },
                                        set: { editedUser.whatsapp = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                }
                                
                                VStack {
                                    TextField("Facebook", text: Binding<String>(
                                        get: { editedUser.facebook ?? "" },
                                        set: { editedUser.facebook = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                    TextField("Facebook Messenger", text: Binding<String>(
                                        get: { editedUser.facebookMessenger ?? "" },
                                        set: { editedUser.facebookMessenger = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                    TextField("Twitter", text: Binding<String>(
                                        get: { editedUser.twitter ?? "" },
                                        set: { editedUser.twitter = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                    TextField("Instagram", text: Binding<String>(
                                        get: { editedUser.instagram ?? "" },
                                        set: { editedUser.instagram = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                    TextField("Telegram", text: Binding<String>(
                                        get: { editedUser.telegram ?? "" },
                                        set: { editedUser.telegram = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                    TextField("LinkedIn", text: Binding<String>(
                                        get: { editedUser.linkedin ?? "" },
                                        set: { editedUser.linkedin = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                    TextField("Discord", text: Binding<String>(
                                        get: { editedUser.discord ?? "" },
                                        set: { editedUser.discord = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                    TextField("YouTube", text: Binding<String>(
                                        get: { editedUser.youtube ?? "" },
                                        set: { editedUser.youtube = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                    
                                    TextField("TikTok", text: Binding<String>(
                                        get: { editedUser.tiktok ?? "" },
                                        set: { editedUser.tiktok = $0.isEmpty ? nil : $0 }
                                    ))
                                    .border(1, .gray.opacity(0.5))
                                    .autocapitalization(.none)
                                }
                            }
                        }
                        HStack {
                            Button("Cancel", action: {
                                showEditPopover.toggle()
                            })
                            .padding(.top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button("Confirm", action: {
                                saveChanges()
                                showEditPopover.toggle()
                            })
                            .padding(.top)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding()
                    .onAppear {
                        guard let myProfile = myProfile else { return }
                        editedUser = myProfile
                        
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        // MARK: Two Action's
                        // 1. Logout
                        // 2. Delete Account
                        Button("Logout",action: logOutUser)
                        
                        Button("Delete Account",role: .destructive,action: deleteAccount)
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
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

