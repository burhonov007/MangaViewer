//
//  TabbarView.swift
//  MangaViewer
//
//  Created by itserviceimac on 27/08/24.
//

import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Главная", systemImage: "house")
                }
            HistoryView()
                .tabItem {
                    Label("История", systemImage: "clock")
                }
            FavoritesView()
                .tabItem {
                    Label("Избранные", systemImage: "star")
                }
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TabbarView()
}
