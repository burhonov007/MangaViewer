//
//  MainView.swift
//  MangaViewer
//
//  Created by itserviceimac on 27/08/24.
//

import SwiftUI


struct MangaCollectionCell: View {
    var index: Int
    
    var body: some View {
        ZStack {
            Image(.jjk)
                .resizable()
            
            VStack(alignment: .leading) {
                Spacer().frame(height: 10)
                
                HStack {
                    
                    Text("Читаю")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                        .background(Color.green)
                        .cornerRadius(5)
                        
                    Text("8%")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                        .background(Color.green)
                        .cornerRadius(5)

                }
                    
                Spacer()
                Text("Магическая битва \(index)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)
                
                ProgressView(value: 8, total: 100)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(5)
                
                    
                Spacer().frame(height: 10)
            }
            .padding(.horizontal, 10)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue)
        .cornerRadius(10)
        .frame(height: 200)
        .contextMenu {
            Button(action: {
                print("Cell \(index) deleted")
            }) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct MangaCollectionView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<8) { index in
                NavigationLink {
                    MangaViewer()
                } label: {
                    MangaCollectionCell(index: index)
                }
            }
            
        }
        .padding()
    }
}


struct MainView: View {
    var body: some View {
        ScrollView(.vertical) {
            MangaCollectionView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Все книги")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("", systemImage: "list.bullet.indent") {
                    print("filter tapped")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("", systemImage: "magnifyingglass") {
                    print("search tapped")
                }
            }
            
        }
    }
}

#Preview {
    NavigationView {
        TabbarView()
    }
}
