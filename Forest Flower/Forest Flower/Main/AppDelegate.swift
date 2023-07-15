//
//  AppDelegate.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 10/06/23.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black.withAlphaComponent(0.3)

        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 20, weight: .heavy)
        ]
        appearance.largeTitleTextAttributes = attrs
        appearance.titleTextAttributes = attrs
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = .black.withAlphaComponent(0.4)
        UITabBar.appearance().unselectedItemTintColor = .white.withAlphaComponent(0.4)

        return true
    }
}
