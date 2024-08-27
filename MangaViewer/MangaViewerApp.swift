//
//  MangaViewerApp.swift
//  MangaViewer
//
//  Created by itserviceimac on 27/08/24.
//

import SwiftUI

@main
struct MangaViewerApp: App {
    
    @State private var showSplash = true
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
                ZStack {
                    if showSplash {
                        LottieView(animationFileName: "Loading.json", loopMode: .loop)
                            .frame(width: 10, height: 10, alignment: .center)
                            .transition(.opacity)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        showSplash = false
                                    }
                                }
                            }
                    } else {
                            TabbarView()
                    }
                }
            }
        }
    }
}
