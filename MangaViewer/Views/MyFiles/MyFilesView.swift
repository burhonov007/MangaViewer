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
    
    var body: some View {
        List(items) { item in
            navigationLink(for: item)
        }
    }
}



@ViewBuilder
func navigationLink(for item: File) -> some View {
    if item.locationType == .folder {
        NavigationLink(
            destination: MyFilesView(items: FileManagerService.shared.fetchContents(of: item.url))
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


func listItemView(for item: File) -> some View {
    HStack {
        item.image
        VStack(alignment: .leading) {
            Text(item.url.lastPathComponent)
                .font(.headline)
        }
    }
    .contextMenu {
        Button(action: {
            // Ваше действие
        }) {
            Label("Action", systemImage: "star")
        }
    }
}





//#Preview {
//    MyFilesView()
//}

#Preview {
    NavigationView {
        MyFilesView(items: FileManagerService.shared.fetchFilesAndFolders())
    }
}


class FileManagerViewModel: ObservableObject {
    @Published var filesAndFolders: [File] = FileManagerService.shared.fetchFilesAndFolders()
    
}




import SwiftUI

public enum LocationType {
    case file
    case folder
}

public enum FileType {
    case mp3
    case cbr
    case png
    case jpg
    case svg
    case mp4
    case unknown
    
    init(fileExtension: String) {
        switch fileExtension.lowercased() {
        case "mp3": self = .mp3
        case "cbr": self = .cbr
        case "png": self = .png
        case "jpg", "jpeg": self = .jpg
        case "svg": self = .svg
        case "mp4": self = .mp4
        default: self = .unknown
        }
    }
}

public enum FileTypeImage {
    case folder
    case mp3
    case cbr
    case png
    case jpg
    case svg
    case mp4
    case unknown
    
    var image: Image {
        switch self {
        case .folder:
            return Image(systemName: "folder.fill")
        case .mp3:
            return Image(systemName: "music.note")
        case .cbr:
            return Image(systemName: "book.fill")
        case .png, .jpg, .svg:
            return Image(systemName: "photo")
        case .mp4:
            return Image(systemName: "film")
        case .unknown:
            return Image(systemName: "questionmark")
        }
    }
}


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



import Foundation
import SwiftUI

// Модель для хранения информации о файле или папке
struct File: Identifiable, Hashable {
    let id = UUID()
    let url: URL
    let locationType: LocationType
    let fileType: FileType
    var isImage: Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "tiff", "bmp", "heif"]
        return imageExtensions.contains(url.pathExtension.lowercased())
    }
    
    // Инициализатор для создания FileLocation на основе URL
    init(url: URL) {
        self.url = url
        let fileExtension = url.pathExtension
        if fileExtension.isEmpty {
            self.locationType = .folder
            self.fileType = .unknown
        } else {
            self.locationType = .file
            self.fileType = FileType(fileExtension: fileExtension)
        }
    }
    
    // Получение изображения для текущего типа
    var image: Image {
        switch locationType {
        case .folder:
            return FileTypeImage.folder.image
        case .file:
            return fileTypeImage.image
        }
    }
    
    private var fileTypeImage: FileTypeImage {
        switch fileType {
        case .mp3: return .mp3
        case .cbr: return .cbr
        case .png: return .png
        case .jpg: return .jpg
        case .svg: return .svg
        case .mp4: return .mp4
        case .unknown: return .unknown
        }
    }
}





import Foundation

class FileManagerService {
    
    static let shared: FileManagerService = FileManagerService()
    
    let fileManager = FileManager.default
    private var documentsURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - File Operations
    
    func createFile(named name: String, withContent content: Data) -> Bool {
        let fileURL = documentsURL.appendingPathComponent(name)
        return fileManager.createFile(atPath: fileURL.path, contents: content, attributes: nil)
    }
    
    func deleteFile(named name: String) -> Bool {
        let fileURL = documentsURL.appendingPathComponent(name)
        do {
            try fileManager.removeItem(at: fileURL)
            return true
        } catch {
            print("Error deleting file: \(error)")
            return false
        }
    }
    
    func readFile(named name: String) -> Data? {
        let fileURL = documentsURL.appendingPathComponent(name)
        return fileManager.contents(atPath: fileURL.path)
    }
    
    func writeFile(named name: String, withContent content: Data) -> Bool {
        let fileURL = documentsURL.appendingPathComponent(name)
        do {
            try content.write(to: fileURL)
            return true
        } catch {
            print("Error writing file: \(error)")
            return false
        }
    }
    
    // MARK: - Directory Operations
    
    func fetchFilesAndFolders() -> [File] {
        do {
            let contents = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            return contents.map { File(url: $0) }
        } catch {
            print("Error fetching contents of directory: \(error)")
            return []
        }
    }
    
    func createDirectory(named name: String) {
        let directoryURL = documentsURL.appendingPathComponent(name)
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating directory: \(error)")
        }
    }
    
    func deleteDirectory(named name: String) -> Bool {
        let directoryURL = documentsURL.appendingPathComponent(name)
        do {
            try fileManager.removeItem(at: directoryURL)
            return true
        } catch {
            print("Error deleting directory: \(error)")
            return false
        }
    }
    
    
    func fetchContents(of directoryURL: URL) -> [File] {
        do {
            let contents = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            return contents.map { File(url: $0) }
        } catch {
            print("Error fetching contents of directory: \(error)")
            return []
        }
        
    }
    
    func getApplicationDirectory(named name: String) -> URL? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsURL.appendingPathComponent(name)
    }
    
    func createDirectoryIfNeeded(at url: URL) {
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                print("Directory created at \(url)")
            } catch {
                print("Failed to create directory: \(error.localizedDescription)")
            }
        }
    }
    
}
