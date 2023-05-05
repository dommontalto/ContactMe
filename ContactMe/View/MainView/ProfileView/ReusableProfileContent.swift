import SwiftUI
import MessageUI
import SDWebImageSwiftUI

struct ReusableProfileContent: View {
    @State private var isShowingMailView = false
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
                ForEach(0..<12) { index in
                    switch index {
                    case 0:
                        if let location = user.location {
                            profileDetailRow(imageName: "location", detailText: location)
                        }
                    case 1:
                        if let birthday = user.birthday {
                            profileDetailRow(imageName: "birthday", detailText: birthday)
                        }
                    case 2:
                        if let email = user.email {
                            profileDetailRow(imageName: "email", detailText: email)
                        }
                    case 3:
                        if let mobile = user.mobile {
                            profileDetailRow(imageName: "mobile", detailText: mobile)
                        }
                    case 4:
                        if let whatsapp = user.whatsapp {
                            profileDetailRow(imageName: "whatsapp", detailText: whatsapp)
                        }
                    case 5:
                        if let facebook = user.facebook {
                            profileDetailRow(imageName: "facebook", detailText: facebook)
                        }
                    case 6:
                        if let facebookMessenger = user.facebookMessenger {
                            profileDetailRow(imageName: "facebookMessenger", detailText: facebookMessenger)
                        }
                    case 7:
                        if let twitter = user.twitter {
                            profileDetailRow(imageName: "twitter", detailText: twitter)
                        }
                    case 8:
                        if let instagram = user.instagram {
                            profileDetailRow(imageName: "instagram", detailText: instagram)
                        }
                    case 9:
                        if let telegram = user.telegram {
                            profileDetailRow(imageName: "telegram", detailText: telegram)
                        }
                    case 10:
                        if let linkedin = user.linkedin {
                            profileDetailRow(imageName: "linkedin", detailText: linkedin)
                        }
                    case 11:
                        if let discord = user.discord {
                            profileDetailRow(imageName: "discord", detailText: discord)
                        }
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    fileprivate func profileDetailRow(imageName: String, detailText: String) -> some View {
        HStack(spacing: 12) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            Text(detailText)
        }
    }
    
    func composeEmail(to emailAddress: String) {
        if MFMailComposeViewController.canSendMail() {
            isShowingMailView = true
        } else {
            print("Mail services are not available")
        }
    }

       func callNumber(phoneNumber: String) {
           if let phoneURL = URL(string: "tel://\(phoneNumber)") {
               if UIApplication.shared.canOpenURL(phoneURL) {
                   UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
               } else {
                   print("Call services are not available")
               }
           }
       }

       func searchTwitterProfile(username: String) {
           if let twitterURL = URL(string: "https://twitter.com/\(username)") {
               UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
           } else {
               print("Invalid Twitter URL")
           }
       }
   
}



