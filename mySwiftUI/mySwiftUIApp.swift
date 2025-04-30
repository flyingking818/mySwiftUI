//
//  mySwiftUIApp.swift
//  mySwiftUI
//
//  Created by Jeremy Wang on 4/16/25.
//

import SwiftUI

@main
struct mySwiftUIApp: App {
    
    // Customize tab bar appearance
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            TabView {
                
                ISeeFoodView()
                    .tabItem {
                        Image(systemName: "camera.viewfinder")
                        Text("ISeeFood")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
                ChatView()
                    .tabItem {
                        Image(systemName: "bubble.right.circle")
                        Text("Ask Saint")
                    }
            }
            
        }
    }
}
