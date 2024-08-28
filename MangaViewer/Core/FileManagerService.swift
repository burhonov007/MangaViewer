//
//  FileManagerService.swift
//  MangaViewer
//
//  Created by itserviceimac on 28/08/24.
//

import Foundation


class FileManagerService {
    
    static let shared: FileManagerService = FileManagerService()
    
    private let fileManager = FileManager.default
    var documentsURL: URL
    
       
   private init() {
       self.documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
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
            documentsURL = directoryURL
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
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                print("Directory created at \(url)")
            } catch {
                print("Failed to create directory: \(error.localizedDescription)")
            }
        }
    }
    
}
