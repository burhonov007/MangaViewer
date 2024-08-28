//
//  ImageView.swift
//  MangaViewer
//
//  Created by itserviceimac on 28/08/24.
//

import SwiftUI


struct ImageView: View {
    let imageURL: URL
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                if let uiImage = UIImage(contentsOfFile: imageURL.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Unable to load image")
                }
            }
        }
        
    }
}


//#Preview {
//    ImageView(imageURL: <#URL#>)
//}
