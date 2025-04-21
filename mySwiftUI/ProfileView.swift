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
    @State private var Comments: [String] = []
    
    
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
                
                
                
            }
        }
    }
}

#Preview {
    ProfileView()
}

