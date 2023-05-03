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

                // Add the icons and text here
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Image("Mobile") // Replace with your mobile image name
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                    HStack(spacing: 12) {
                        Image("Email") // Replace with your email image name
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                    HStack(spacing: 12) {
                        Image("Twitter") // Replace with your Twitter image name
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                    HStack(spacing: 12) {
                        Image("Instagram") // Replace with your Instagram image name
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                    HStack(spacing: 12) {
                        Image("Telegram") // Replace with your Telegram image name
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 8)
            }
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
        }
    }
}
