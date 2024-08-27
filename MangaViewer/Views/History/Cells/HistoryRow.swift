//
//  HistoryRow.swift
//  MangaViewer
//
//  Created by itserviceimac on 27/08/24.
//

import SwiftUI


struct HistoryRow: View {
    
    var body: some View {
        HStack {
            Image(.jjk)
                .resizable()
                .scaledToFill()
                .frame(width: 80)
                .frame(height: 120)
                .cornerRadius(7)
                
            
            VStack(alignment: .leading) {
                Spacer().frame(height: 10)
                
                Text("Магическая битва 267 - Земли дявола противостояния в Синдзюку")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)
                
                Spacer()
                
                HStack(spacing: 0) {

                    Text("27 авг. 2024 г. 15:50:02")
                        .font(.system(size: 12, weight: .medium))
                    
                    Spacer()
                    
                    Text("13.5 МБ")
                        .font(.system(size: 12, weight: .medium))

                }
                    
                ProgressView(value: 8, total: 100)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(5)
                    .tint(.black)
                
                    
                Spacer().frame(height: 10)
            }
            .padding(.horizontal, 10)

        }
        .frame(maxWidth: .infinity, maxHeight: 120)
        .background(Color.white)
        .frame(height: 120)
        .padding(5)
        .overlay(
            RoundedRectangle(cornerRadius: 10) // Бордер с закругленными краями
                .stroke(Color.gray, lineWidth: 1)
        )
        
        .contextMenu {
            Button(action: {
                print("Cell deleted")
            }) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    HistoryRow().padding(15)
}
