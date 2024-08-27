//
//  MainView.swift
//  MangaViewer
//
//  Created by itserviceimac on 27/08/24.
//

import SwiftUI

struct MainView: View {
    
    @Binding var rowType: RowType
    @Binding var listType: ListType
    
    var body: some View {
        ScrollView(.vertical) {
            MangaList(rowType: $rowType, listType: $listType)
        }
    }
}

#Preview {
    TabbarView()
}
