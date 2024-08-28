//
//  File.swift
//  MangaViewer
//
//  Created by itserviceimac on 28/08/24.
//

import Foundation
import SwiftUI


struct File: Identifiable, Hashable {
    let id = UUID()
    let url: URL
    let locationType: LocationType
    let fileType: FileType
    var isImage: Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "tiff", "bmp", "heif"]
        return imageExtensions.contains(url.pathExtension.lowercased())
    }
    
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
