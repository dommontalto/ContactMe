import SwiftUI
import MessageUI
import SDWebImageSwiftUI
import MapKit

struct ReusableProfileContent: View {
    @State private var isShowingMailView = false
    var user: User
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 6) {
                        WebImage(url: user.userProfileURL).placeholder {
                            // MARK: Placeholder Image
                            Image("NullProfile")
                                .resizable()
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.top, -10)
                        
                        Text(user.fullName ?? "")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                        
                        Text(user.userPIN ?? "")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(3)
                    }
                    .padding(.bottom, -10)
                    Spacer()
                }
                .background(Color(UIColor.systemGroupedBackground))
            }
            .listRowBackground(Color(UIColor.systemGroupedBackground))
            
            Section {
                ForEach(0..<14) { index in
                    switch index {
                    case 0:
                        if let location = user.location {
                            profileDetailRow(imageName: "location", detailText: location)
                                .onTapGesture {
                                    searchLocationInAppleMaps(searchText: location)
                                }
                        }
                    case 1:
                        if let birthday = user.birthday {
                            profileDetailRow(imageName: "birthday", detailText: birthday)
                        }
                    case 2:
                        if let email = user.email {
                            profileDetailRow(imageName: "email", detailText: email)
                                .onTapGesture {
                                    composeEmail(to: email)
                                }
                        }
                    case 3:
                        if let mobile = user.mobile {
                            profileDetailRow(imageName: "mobile", detailText: mobile)
                                .onTapGesture {
                                    callNumber(phoneNumber: mobile)
                                }
                        }
                    case 4:
                        if let whatsapp = user.whatsapp {
                            profileDetailRow(imageName: "whatsapp", detailText: whatsapp)
                                .onTapGesture {
                                    searchWhatsApp(phoneNumber: whatsapp)
                                }
                        }
                    case 5:
                        if let facebook = user.facebook {
                            profileDetailRow(imageName: "facebook", detailText: facebook)
                                .onTapGesture {
                                    searchFacebookProfile(username: facebook)
                                }
                        }
                    case 6:
                        if let facebookMessenger = user.facebookMessenger {
                            profileDetailRow(imageName: "facebookMessenger", detailText: facebookMessenger)
                                .onTapGesture {
                                    searchFacebookMessenger(username: facebookMessenger)
                                }
                        }
                    case 7:
                        if let twitter = user.twitter {
                            profileDetailRow(imageName: "twitter", detailText: twitter)
                                .onTapGesture {
                                    searchTwitterProfile(username: twitter)
                                }
                        }
                    case 8:
                        if let instagram = user.instagram {
                            profileDetailRow(imageName: "instagram", detailText: instagram)
                                .onTapGesture {
                                    searchInstagramProfile(username: instagram)
                                }
                        }
                    case 9:
                        if let telegram = user.telegram {
                            profileDetailRow(imageName: "telegram", detailText: telegram)
                                .onTapGesture {
                                    searchTelegramProfile(username: telegram)
                                }
                        }
                    case 10:
                        if let linkedin = user.linkedin {
                            profileDetailRow(imageName: "linkedin", detailText: linkedin)
                                .onTapGesture {
                                    searchLinkedInProfile(id: linkedin)
                                }
                        }
                    case 11:
                        if let discord = user.discord {
                            profileDetailRow(imageName: "discord", detailText: discord)
                                .onTapGesture {
                                    searchDiscordProfile(tag: discord)
                                }
                        }
                    case 12:
                        if let youtube = user.youtube {
                            profileDetailRow(imageName: "youtube", detailText: youtube)
                                .onTapGesture {
                                    searchYoutubeChannel(channelId: youtube)
                                }
                        }
                    case 13:
                        if let tiktok = user.tiktok {
                            profileDetailRow(imageName: "tiktok", detailText: tiktok)
                                .onTapGesture {
                                    searchTiktokProfile(username: tiktok)
                                }
                        }
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(toRecipients: [user.email ?? ""], subject: "Hello", bodyText: "This is a sample email.")
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
                .opacity(0.9)
            Text(detailText)
        }
    }

    func searchLocationInAppleMaps(searchText: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response, let mapItem = response.mapItems.first else {
                print("Error searching for location: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            mapItem.openInMaps(launchOptions: nil)
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
    
    func searchWhatsApp(phoneNumber: String) {
        let phoneNumberFormatted = phoneNumber.replacingOccurrences(of: " ", with: "")
        
        if let whatsappAppURL = URL(string: "https://wa.me/\(phoneNumberFormatted)") {
            if UIApplication.shared.canOpenURL(whatsappAppURL) {
                UIApplication.shared.open(whatsappAppURL, options: [:], completionHandler: nil)
            } else {
                if let appStoreURL = URL(string: "https://apps.apple.com/app/whatsapp-messenger/id310633997") {
                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                } else {
                    print("Invalid App Store URL")
                }
            }
        } else {
            print("Invalid WhatsApp URL")
        }
    }

    
    func searchFacebookProfile(username: String) {
        if let facebookAppURL = URL(string: "fb://profile/\(username)") {
            if UIApplication.shared.canOpenURL(facebookAppURL) {
                UIApplication.shared.open(facebookAppURL, options: [:], completionHandler: nil)
            } else {
                if let facebookWebURL = URL(string: "https://www.facebook.com/\(username)") {
                    UIApplication.shared.open(facebookWebURL, options: [:], completionHandler: nil)
                } else {
                    print("Invalid Facebook URL")
                }
            }
        }
    }
    
    func searchFacebookMessenger(username: String) {
        if let messengerAppURL = URL(string: "fb-messenger://user/\(username)") {
            if UIApplication.shared.canOpenURL(messengerAppURL) {
                UIApplication.shared.open(messengerAppURL, options: [:], completionHandler: nil)
            } else if let appStoreURL = URL(string: "https://apps.apple.com/app/id454638411") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            } else {
                print("Unable to open Facebook Messenger in the App Store")
            }
        }
    }
    
    func searchTwitterProfile(username: String) {
        if let twitterAppURL = URL(string: "twitter://user?screen_name=\(username)"),
           UIApplication.shared.canOpenURL(twitterAppURL) {
            UIApplication.shared.open(twitterAppURL, options: [:], completionHandler: nil)
        } else if let twitterWebURL = URL(string: "https://twitter.com/\(username)") {
            UIApplication.shared.open(twitterWebURL, options: [:], completionHandler: nil)
        } else {
            print("Invalid Twitter URL")
        }
    }
    
    func searchInstagramProfile(username: String) {
        if let instagramAppURL = URL(string: "instagram://user?username=\(username)"),
           UIApplication.shared.canOpenURL(instagramAppURL) {
            UIApplication.shared.open(instagramAppURL, options: [:], completionHandler: nil)
        } else if let instagramWebURL = URL(string: "https://www.instagram.com/\(username)") {
            UIApplication.shared.open(instagramWebURL, options: [:], completionHandler: nil)
        } else {
            print("Invalid Instagram URL")
        }
    }
    
    func searchTelegramProfile(username: String) {
        if let telegramAppURL = URL(string: "tg://resolve?domain=\(username)"),
           UIApplication.shared.canOpenURL(telegramAppURL) {
            UIApplication.shared.open(telegramAppURL, options: [:], completionHandler: nil)
        } else if let telegramWebURL = URL(string: "https://t.me/\(username)") {
            UIApplication.shared.open(telegramWebURL, options: [:], completionHandler: nil)
        } else {
            print("Invalid Telegram URL")
        }
    }
    
    func searchLinkedInProfile(id: String) {
        if let linkedInAppURL = URL(string: "linkedin://profile/\(id)"),
           UIApplication.shared.canOpenURL(linkedInAppURL) {
            UIApplication.shared.open(linkedInAppURL, options: [:], completionHandler: nil)
        } else if let linkedInWebURL = URL(string: "https://www.linkedin.com/in/\(id)") {
            UIApplication.shared.open(linkedInWebURL, options: [:], completionHandler: nil)
        } else {
            print("Invalid LinkedIn URL")
        }
    }
    
    func searchDiscordProfile(tag: String) {
        if let discordWebURL = URL(string: "https://discordapp.com/users/\(tag)") {
            UIApplication.shared.open(discordWebURL, options: [:], completionHandler: nil)
        } else {
            print("Invalid Discord URL")
        }
    }
    
    func searchYoutubeChannel(channelId: String) {
        if let youtubeAppURL = URL(string: "youtube://www.youtube.com/channel/\(channelId)") {
            if UIApplication.shared.canOpenURL(youtubeAppURL) {
                UIApplication.shared.open(youtubeAppURL, options: [:], completionHandler: nil)
            } else {
                if let youtubeWebURL = URL(string: "https://www.youtube.com/channel/\(channelId)") {
                    UIApplication.shared.open(youtubeWebURL, options: [:], completionHandler: nil)
                } else {
                    print("Invalid YouTube URL")
                }
            }
        }
    }
    
    func searchTiktokProfile(username: String) {
        if let tiktokAppURL = URL(string: "tiktok://user?username=\(username)") {
            if UIApplication.shared.canOpenURL(tiktokAppURL) {
                UIApplication.shared.open(tiktokAppURL, options: [:], completionHandler: nil)
            } else {
                if let tiktokWebURL = URL(string: "https://www.tiktok.com/@\(username)") {
                    UIApplication.shared.open(tiktokWebURL, options: [:], completionHandler: nil)
                } else {
                    print("Invalid TikTok URL")
                }
            }
        }
    }





    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ReusableProfileContent(user: User(fullName: "Dom Montalto", userPIN: "12345678",location: "England, United Kingdom"))
        }
    }
    
}



