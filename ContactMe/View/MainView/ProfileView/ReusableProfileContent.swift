import SwiftUI
import SDWebImageSwiftUI

struct ReusableProfileContent: View {
    var user: User
    
    var body: some View {
        List {
            Section {
                VStack {
                    HStack(spacing: 12) {
                        WebImage(url: user.userProfileURL).placeholder {
                            // MARK: Placeholder Image
                            Image("NullProfile")
                                .resizable()
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.leading, -20)
                        .padding(.top, -10)     
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(user.fullName ?? "")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.leading, 5)
                            
                            Text(user.userPIN ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(3)
                                .padding(.leading, 5)
                        }
                    }
                }
                .background(Color(UIColor.systemGroupedBackground))
            }
            .listRowBackground(Color(UIColor.systemGroupedBackground))
            
            Section {
                if let mobile = user.mobile {
                    HStack(spacing: 12) {
                        Image("mobile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        Text(mobile)
                    }
                    .padding(.leading, -8)
                }
                
                if let email = user.email {
                    HStack(spacing: 12) {
                        Image("email")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        Text(email)
                    }
                    .padding(.leading, -8)
                }
                
                if let twitter = user.twitter {
                    HStack(spacing: 12) {
                        Image("twitter")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        Text(twitter)
                    }
                    .padding(.leading, -8)
                }
                
                if let instagram = user.instagram {
                    HStack(spacing: 12) {
                        Image("instagram")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        Text(instagram)
                    }
                    .padding(.leading, -8)
                }
                
                if let telegram = user.telegram {
                    HStack(spacing: 12) {
                        Image("telegram")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        Text(telegram)
                    }
                    .padding(.leading, -8)
                }
               
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
