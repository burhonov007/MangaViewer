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
        case .cbr: return .cbr
        case .zip: return .zip
        case .png: return .png
        case .jpg: return .jpg
        case .unknown: return .unknown
        }
    }
}

public enum LocationType {
    case file
    case folder
}

public enum FileType {
    case cbr
    case zip
    case png
    case jpg
    case unknown
    
    init(fileExtension: String) {
        switch fileExtension.lowercased() {
        case "zip": self = .zip
        case "png": self = .png
        case "jpg", "jpeg": self = .jpg
        default: self = .unknown
        }
    }
}

public enum FileTypeImage {
    case folder
    case cbr
    case zip
    case png
    case jpg
    case unknown
    
    var image: Image {
        switch self {
        case .folder:
            return Image(systemName: "folder.fill")
        case .cbr, .zip:
            return Image(systemName: "book.fill")
        case .png, .jpg:
            return Image(systemName: "photo")
        case .unknown:
            return Image(systemName: "questionmark")
        }
    }
}
