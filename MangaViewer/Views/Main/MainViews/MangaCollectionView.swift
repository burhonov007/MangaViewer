//
//  MangaCollectionView.swift
//  MangaViewer
//
//  Created by itserviceimac on 27/08/24.
//

import SwiftUI

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

#Preview {
    MangaCollectionView()
}
