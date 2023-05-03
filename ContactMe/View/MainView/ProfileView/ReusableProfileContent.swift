//
//  ReusableProfileContent.swift
//  SocialMedia
//
//  Created by Balaji on 14/12/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReusableProfileContent: View {
    var user: User
   
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading) {
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
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(user.fullName)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(user.userPIN)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(3)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    if let mobile = user.mobile {
                        HStack(spacing: 12) {
                            Image("Mobile")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            Text(mobile)
                        }
                    }
                    
                    if let twitter = user.twitter {
                        HStack(spacing: 12) {
                            Image("Twitter")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            Text(twitter)
                        }
                    }
                    
                    if let instagram = user.instagram {
                        HStack(spacing: 12) {
                            Image("Instagram")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            Text(instagram)
                        }
                    }
                    
                    if let telegram = user.telegram {
                        HStack(spacing: 12) {
                            Image("Telegram")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            Text(telegram)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
        }
    }
}
