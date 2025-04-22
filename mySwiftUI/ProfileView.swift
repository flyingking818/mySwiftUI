//
//  ContentView.swift
//  mySwiftUI
//
//  Created by Jeremy Wang on 4/16/25.
//

import SwiftUI

struct ProfileView: View {
    //Declare some properties
    
    @State private var newComment: String = ""
    @State private var comments: [String] = []
    
    
    var body: some View {
        
        ZStack{
            Color(UIColor(red: 0.75, green: 0.22, blue: 0.17, alpha: 1))
                .ignoresSafeArea()
            
            VStack(spacing: 16){
                Image("Jeremy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.yellow, lineWidth: 6))
                    .shadow(radius: 8)
                
                Text("Hi Flagler Student")
                    .font(.title2)
                    .bold()
                    .italic()
                    .underline()
                    .foregroundColor(.white)
                
                HStack{
                    Text("Comment: 💬")
                        .foregroundColor(.white)
                    
                    TextField("Add your comments here", text: $newComment)
                        .frame(height: 40)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding()
                
                //Adds the comment to the comments array — at the top (index 0), not the end.
                Button(action: {
                    if !newComment.trimmingCharacters(in: .whitespaces).isEmpty {
                        comments.insert(newComment, at: 0)
                        newComment = ""
                    }
                }) {
                    Text("Post Comment 🎉")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(comments, id: \.self) { comment in
                            Text("💬 \(comment)")
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .padding()
            
            
        }
    }
}


#Preview {
    ProfileView()
}

