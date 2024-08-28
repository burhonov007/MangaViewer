//
//  MyFilesView.swift
//  MangaViewer
//
//  Created by itserviceimac on 28/08/24.
//

import SwiftUI

struct MyFilesView: View {
    @StateObject private var viewModel = FileManagerViewModel()
    var items: [File] = FileManagerService.shared.fetchFilesAndFolders()
    
    var body: some View {
        List(items, id: \.self) { item in
            if item.locationType == .folder { // Проверяем, является ли элемент директорией
                NavigationLink(
                    destination: MyFilesView(items: FileManagerService.shared.fetchContents(of: item.url))
                ) {
                    HStack {
                        item.image
                        VStack(alignment: .leading) {
                            Text(item.url.lastPathComponent)
                                .font(.headline)
                            Text(item.url.absoluteString)
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                    }
                }
            } else {
                HStack {
                    item.image
                    VStack(alignment: .leading) {
                        Text(item.url.lastPathComponent)
                            .font(.headline)
                        Text(item.url.absoluteString)
                            .font(.subheadline)
                            .lineLimit(1)
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
        }

    }
}

//#Preview {
//    MyFilesView()
//}

#Preview {
    NavigationView {
        MyFilesView()
    }
}


class FileManagerViewModel: ObservableObject {
    @Published var filesAndFolders: [File] = FileManagerService.shared.fetchFilesAndFolders()
    
    @Published var filesFolders: [File] = FileManagerService.shared.createFakeFilesAndFolders()
    
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





import Foundation
import SwiftUI

// Модель для хранения информации о файле или папке
struct File: Identifiable, Hashable {
    let id = UUID()
    let url: URL
    let locationType: LocationType
    let fileType: FileType
    
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
    
    func createDirectory(named name: String) -> Bool {
        let directoryURL = documentsURL.appendingPathComponent(name)
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            print("Error creating directory: \(error)")
            return false
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
    
    func fetchContents(of directoryURL: URL) -> [URL] {
            do {
                let contents = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                return contents
            } catch {
                print("Error fetching contents of directory: \(error)")
                return []
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
    
    func createFakeFilesAndFolders() -> [File] {
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            // Основные папки и файлы
            let folder1URL = documentsURL.appendingPathComponent("Folder1")
            let folder2URL = documentsURL.appendingPathComponent("Folder2")
            let file1URL = documentsURL.appendingPathComponent("File1.mp3")
            let file2URL = documentsURL.appendingPathComponent("File2.png")
            let file3URL = documentsURL.appendingPathComponent("File3.cbr")
            let file4URL = documentsURL.appendingPathComponent("File4.unknown") // Исправлено на 'unknown'
            
            // Файлы и папки внутри Folder2
            let folder2SubFolderURL = folder2URL.appendingPathComponent("SubFolder")
            let folder2File1URL = folder2URL.appendingPathComponent("File5.mp4")
            let folder2File2URL = folder2URL.appendingPathComponent("File6.svg")
            
            // Создание директорий и файлов
            do {
                try fileManager.createDirectory(at: folder1URL, withIntermediateDirectories: true, attributes: nil)
                try fileManager.createDirectory(at: folder2URL, withIntermediateDirectories: true, attributes: nil)
                fileManager.createFile(atPath: file1URL.path, contents: "This is File 1".data(using: .utf8))
                fileManager.createFile(atPath: file2URL.path, contents: "This is File 2".data(using: .utf8))
                fileManager.createFile(atPath: file3URL.path, contents: "This is File 3".data(using: .utf8))
                fileManager.createFile(atPath: file4URL.path, contents: "This is File 4".data(using: .utf8))
                
                // Создание содержимого для Folder2
                try fileManager.createDirectory(at: folder2SubFolderURL, withIntermediateDirectories: true, attributes: nil)
                fileManager.createFile(atPath: folder2File1URL.path, contents: "This is File 5".data(using: .utf8))
                fileManager.createFile(atPath: folder2File2URL.path, contents: "This is File 6".data(using: .utf8))
                
            } catch {
                print("Error creating fake files and folders: \(error)")
            }
            
            return [
                File(url: folder1URL),
                File(url: folder2URL),
                File(url: file1URL),
                File(url: file2URL),
                File(url: file3URL),
                File(url: file4URL)
            ]
        }
}
