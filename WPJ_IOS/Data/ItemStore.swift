//
//  ItemStore.swift
//  WPJ_IOS
//

import Foundation
import UIKit

enum ItemStore {
    private static let itemsFileName = "items.json"
    private static let imagesDirectoryName = "item_images"

    static func save(
        name: String,
        productionDate: Date,
        expiryDate: Date,
        remindEnabled: Bool,
        remindOption: ReminderOption?,
        image: UIImage?
    ) throws {
        var items = try loadAll()
        let id = UUID()

        let imageFileName: String?
        if let image {
            imageFileName = try saveImage(image, id: id)
        } else {
            imageFileName = nil
        }

        let item = StoredItem(
            id: id,
            name: name,
            productionDate: productionDate,
            expiryDate: expiryDate,
            remindEnabled: remindEnabled,
            remindOption: remindOption,
            imageFileName: imageFileName,
            createdAt: Date()
        )

        items.insert(item, at: 0)
        try persist(items)
    }

    static func loadAll() throws -> [StoredItem] {
        guard FileManager.default.fileExists(atPath: itemsURL.path) else { return [] }
        let data = try Data(contentsOf: itemsURL)
        return try decoder.decode([StoredItem].self, from: data)
    }

    private static func persist(_ items: [StoredItem]) throws {
        let data = try encoder.encode(items)
        try data.write(to: itemsURL, options: .atomic)
    }

    private static func saveImage(_ image: UIImage, id: UUID) throws -> String {
        try FileManager.default.createDirectory(
            at: imagesDirectoryURL,
            withIntermediateDirectories: true
        )

        let fileName = "\(id.uuidString).jpg"
        let fileURL = imagesDirectoryURL.appendingPathComponent(fileName)

        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            throw StoreError.imageEncodingFailed
        }

        try imageData.write(to: fileURL, options: .atomic)
        return fileName
    }

    private static var itemsURL: URL {
        documentsDirectory.appendingPathComponent(itemsFileName)
    }

    private static var imagesDirectoryURL: URL {
        documentsDirectory.appendingPathComponent(imagesDirectoryName, isDirectory: true)
    }

    private static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

enum StoreError: Error {
    case imageEncodingFailed
}
