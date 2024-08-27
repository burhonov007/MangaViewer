//
//  MangaViewer.swift
//  MangaViewer
//
//  Created by itserviceimac on 27/08/24.
//

import SwiftUI

struct MangaViewer: View {
    var body: some View {
        ScrollView(.vertical) {
            ForEach(0..<5) { _ in
                Image(.jjk)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

#Preview {
    MangaViewer()
}
