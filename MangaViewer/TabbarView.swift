//
//  TabbarView.swift
//  MangaViewer
//
//  Created by itserviceimac on 27/08/24.
//

import SwiftUI
import SwiftUI

struct TabbarView: View {
    
    @State private var selectedTab = 0
    @State var alert = false
    
    @State var rowType: RowType = .bigRow
    @State var listType: ListType = .collection
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            MainView(rowType: $rowType, listType: $listType)
                .tabItem {
                    Label("Главная", systemImage: "house")
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    Label("История", systemImage: "clock")
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    Label("Избранные", systemImage: "star")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
                .tag(3)
        }
        .navigationTitle(getNavigationTitle(for: selectedTab))
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if selectedTab == 0 {
                    NavigationLink(destination: EmptyView()) {
                        Image(systemName: "list.bullet.indent")
                            .resizable()
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                    }
                } else if selectedTab == 1 {
                    NavigationLink(destination: EmptyView()) {
                        Image(systemName: "trash")
                            .resizable()
                    }
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarLeading) {
                if selectedTab == 0 {
                    Button(action: {
                        alert = true
                    }, label: {
                        Image(systemName: "rectangle.stack")
                            .resizable()
                    })
                }
            }
        }
        .actionSheet(isPresented: $alert) {
            ActionSheet(
                title: Text("Set status to an anime"),
                buttons: [
                    .default(Text("Collection")) {
                        listType = .collection
                    },
                    .default(Text("BigRow")) {
                        listType = .list
                        rowType = .bigRow
                    },
                    .default(Text("SmallRow")) {
                        listType = .list
                        rowType = .smallRow
                    },
                    .cancel(Text("Отмена"))
                ]
            )
        }
        
        
        
    }
    
    private func getNavigationTitle(for index: Int) -> String {
        switch index {
        case 0: return "Главная"
        case 1: return "История"
        case 2: return "Избранные"
        case 3: return "Настройки"
        default: return ""
        }
    }
    
}

#Preview {
    TabbarView()
}
