//
//  TabbarView.swift
//  MangaViewer
//
//  Created by itserviceimac on 27/08/24.
//

import SwiftUI

struct TabbarView: View {

    init() {
        setupApplicationDirectory()
    }

    @State private var selectedTab = 0
    @State var alert = false
    
    @State var rowType: RowType = .bigRow
    @State var listType: ListType = .collection
    
    @State private var showFolderCreatorPicker = false
    @State private var newFolderName: String = ""
    
    @State private var showDocumentPicker = false
    @State private var documentURL: URL?
    
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
            
            MyFilesView(items: FileManagerService.shared.fetchFilesAndFolders())
                .tabItem {
                    Label("Мой файлы", systemImage: "folder")
                }
                .tag(2)
            
            
            FavoritesView()
                .tabItem {
                    Label("Избранные", systemImage: "star")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
                .tag(4)
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
                } else if selectedTab == 2 {
                    Button(action: {
                        showFolderCreatorPicker = true
                    }, label: {
                        Image(systemName: "folder.fill.badge.plus").resizable()
                    })
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
                } else if selectedTab == 2 {
                    Button(action: {
                        showDocumentPicker = true
                    }, label: {
                        Image(systemName: "plus")
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
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker { url in
                documentURL = url
                copyFileToAppDirectory(from: url)
            }
        }
        .alert("Enter your name", isPresented: $showFolderCreatorPicker) {
                    TextField("Enter your name", text: $newFolderName)
            Button("OK", action: submit)
                } message: {
                    Text("Xcode will print whatever you type.")
                }
           
        
    }
    
    func submit() {
        FileManagerService.shared.createDirectory(named: newFolderName)
    }
    
    private func setupApplicationDirectory() {
        let fileManager = FileManagerService.shared
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "DefaultAppName"
        
        if let appDirectoryURL = fileManager.getApplicationDirectory(named: appName) {
            fileManager.createDirectoryIfNeeded(at: appDirectoryURL)
        }
    }
    
    private func getNavigationTitle(for index: Int) -> String {
        switch index {
        case 0: return "Главная"
        case 1: return "История"
        case 2: return "Эспортированные"
        case 3: return "Избранные"
        case 4: return "Настройки"
        default: return ""
        }
    }
    
    
    func copyFileToAppDirectory(from url: URL) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent(url.lastPathComponent)
        
        do {
            try fileManager.copyItem(at: url, to: destinationURL)
            print("File copied to: \(destinationURL)")
        } catch {
            print("Error copying file: \(error)")
        }
    }
    
}

#Preview {
    TabbarView()
}




import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    var onPick: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: true)
        documentPicker.delegate = context.coordinator
        return documentPicker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: (URL) -> Void
        
        init(onPick: @escaping (URL) -> Void) {
            self.onPick = onPick
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedURL = urls.first else { return }
            onPick(selectedURL)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Document picker was cancelled")
        }
    }
}
