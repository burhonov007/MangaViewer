//
//  HistoryView.swift
//  MangaViewer
//
//  Created by itserviceimac on 27/08/24.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        ScrollView(.vertical) {
            MangaList(rowType: .constant(.historyRow), listType: .constant(.list))
        }
    }
}

#Preview {
    TabbarView()
}
