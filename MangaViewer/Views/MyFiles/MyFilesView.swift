//
//  MyFilesView.swift
//  MangaViewer
//
//  Created by itserviceimac on 28/08/24.
//

import SwiftUI


struct MyFilesView: View {
    @StateObject private var viewModel = FileManagerViewModel()
    @State var items: [File]
    
    @State private var showFolderCreatorPicker = false
    @State private var newFolderName: String = ""
    
    @State private var showDeleteErrorAlert = false
    @State private var deleteErrorMessage: String = ""
    
    var currentDirectoryURL: URL {
        didSet {
            items = FileManagerService.shared.fetchContents(of: currentDirectoryURL)
        }
    }
    
    init(items: [File], currentDirectoryURL: URL) {
        self._items = State(initialValue: items)
        self.currentDirectoryURL = currentDirectoryURL
    }
    
    var body: some View {
        VStack {
            Text("\(currentDirectoryURL.lastPathComponent)")
            List(items) { item in
                navigationLink(for: item)
            }
            .toolbar {
                Button(action: {
                    showFolderCreatorPicker = true
                }, label: {
                    Image(systemName: "folder.fill.badge.plus").resizable()
                })
            }
            .alert("Enter folder name", isPresented: $showFolderCreatorPicker) {
                TextField("Enter folder name", text: $newFolderName)
                Button("OK") {
                    FileManagerService.shared.createDirectory(named: newFolderName)
                    // Refresh the list
                    items = FileManagerService.shared.fetchContents(of: currentDirectoryURL)
                }
            } message: {
                Text("Please enter the name of the new folder.")
            }
            .alert(isPresented: $showDeleteErrorAlert) {
                Alert(title: Text("Delete Error"), message: Text(deleteErrorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    @ViewBuilder
    private func navigationLink(for item: File) -> some View {
        if item.locationType == .folder {
            NavigationLink(
                destination: MyFilesView(
                    items: FileManagerService.shared.fetchContents(of: item.url),
                    currentDirectoryURL: item.url
                )
            ) {
                listItemView(for: item)
            }
        } else if item.isImage {
            NavigationLink(
                destination: ImageView(imageURL: item.url)
            ) {
                listItemView(for: item)
            }
            .navigationTitle("Просмотр")
        } else {
            listItemView(for: item)
        }
    }
    
    private func listItemView(for item: File) -> some View {
        HStack {
            item.image
            VStack(alignment: .leading) {
                Text(item.url.lastPathComponent)
                    .font(.headline)
            }
        }
        .contextMenu {
            Button(action: {
                let success = deleteItem(item)
                if !success {
                    deleteErrorMessage = "Failed to delete \(item.url.lastPathComponent)"
                    showDeleteErrorAlert = true
                }
            }) {
                Label("Удалить", systemImage: "trash")
            }
            
            if item.fileType == .zip {
                Button(action: {
                    FileManagerService.shared.unZip(at: item.url)
                }) {
                    Label("Распаковать", systemImage: "archivebox")
                }
            }
            
        }
    }
    
    private func deleteItem(_ item: File) -> Bool {
        let success: Bool
        FileManagerService.shared.documentsURL = currentDirectoryURL
        if item.locationType == .folder {
            success = FileManagerService.shared.deleteDirectory(named: item.url.lastPathComponent)
        } else {
            success = FileManagerService.shared.deleteFile(named: item.url.lastPathComponent)
        }
        
        if success {
            items = FileManagerService.shared.fetchContents(of: currentDirectoryURL)
        }
        
        return success
    }
}



//#Preview {
//    MyFilesView()
//}


class FileManagerViewModel: ObservableObject {
    @Published var filesAndFolders: [File] = FileManagerService.shared.fetchFilesAndFolders()
    
}

