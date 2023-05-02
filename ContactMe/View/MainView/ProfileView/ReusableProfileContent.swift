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
            LazyVStack{
                HStack(spacing: 12){
                    WebImage(url: user.userProfileURL).placeholder{
                        // MARK: Placeholder Imgae
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
                    .hAlign(.leading)
                }
                
            }
            .padding(15)
        }
    }
}
