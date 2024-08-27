//
//  MangaViewerApp.swift
//  MangaViewer
//
//  Created by itserviceimac on 27/08/24.
//

import SwiftUI

@main
struct MangaViewerApp: App {
    
    init() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabbarView()
            }
        }
    }
}
