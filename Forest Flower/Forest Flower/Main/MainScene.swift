//
//  MainScene.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 10/06/23.
//

import SwiftUI

struct MainScene: Scene {
    
    @Environment(\.scenePhase)
    var scenePhase
    
    @AppStorage("selectedTab")
    var selectedTab: Tab = .home
    
    var body: some Scene {
        let group = WindowGroup {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        SystemImage.photoStack
                    }
                    .tag(Tab.home)

                SearchResultView()
                    .tabItem {
                        SystemImage.search
                    }
                    .tag(Tab.search)
                
                SavedPhotosView()
                    .tabItem {
                        SystemImage.saveWithArrow
                    }
                    .tag(Tab.bookmark)
                
                LikesView()
                    .tabItem {
                        SystemImage.heart
                    }
                    .tag(Tab.likes)
            }
            .tint(Color.white)
        }
        return group
    }
}

enum Tab: String {
    case home
    case search
    case bookmark
    case likes
}
