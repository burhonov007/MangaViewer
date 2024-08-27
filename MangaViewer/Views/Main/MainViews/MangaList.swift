//
//  MangaList.swift
//  MangaViewer
//
//  Created by itserviceimac on 27/08/24.
//

import SwiftUI

struct MangaList: View {
    
    @Binding var rowType: RowType
    @Binding var listType: ListType
    
    var body: some View {
        switch listType {
        case .list:
            LazyVStack(content: {
                ForEach(0..<8) { index in
                    NavigationLink {
                        MangaViewer()
                    } label: {
                        switch rowType {
                        case .smallRow:
                            SmallMangaRow()
                        case .bigRow:
                            MangaRow()
                        case .historyRow:
                            HistoryRow()
                        }
                    }
                }
            })
            .padding(.horizontal, 15)
        case .collection:
            MangaCollectionView()
        }
    }
}


enum RowType {
    case smallRow
    case bigRow
    case historyRow
}

enum ListType {
    case collection
    case list
}


#Preview {
    MangaList(rowType: .constant(.bigRow), listType: .constant(.collection))
}
