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

    static func update(
        id: UUID,
        name: String,
        productionDate: Date,
        expiryDate: Date,
        remindEnabled: Bool,
        remindOption: ReminderOption?,
        image: UIImage?
    ) throws {
        var items = try loadAll()
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }

        let existing = items[index]
        let imageFileName = try resolveImageFileName(
            for: id,
            existingFileName: existing.imageFileName,
            image: image
        )

        items[index] = StoredItem(
            id: existing.id,
            name: name,
            productionDate: productionDate,
            expiryDate: expiryDate,
            remindEnabled: remindEnabled,
            remindOption: remindOption,
            imageFileName: imageFileName,
            createdAt: existing.createdAt
        )

        try persist(items)
    }

    static func delete(id: UUID) throws {
        var items = try loadAll()
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        let item = items.remove(at: index)

        if let imageFileName = item.imageFileName {
            try? FileManager.default.removeItem(at: imagesDirectoryURL.appendingPathComponent(imageFileName))
        }

        try persist(items)
    }

    static func loadAll() throws -> [StoredItem] {
        guard FileManager.default.fileExists(atPath: itemsURL.path) else { return [] }
        let data = try Data(contentsOf: itemsURL)
        return try makeDecoder().decode([StoredItem].self, from: data)
    }

    static func loadImage(fileName: String) -> UIImage? {
        UIImage(contentsOfFile: imagesDirectoryURL.appendingPathComponent(fileName).path)
    }

    private static func persist(_ items: [StoredItem]) throws {
        let data = try makeEncoder().encode(items)
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

    private static func resolveImageFileName(
        for id: UUID,
        existingFileName: String?,
        image: UIImage?
    ) throws -> String? {
        guard let image else {
            if let existingFileName {
                try? FileManager.default.removeItem(at: imagesDirectoryURL.appendingPathComponent(existingFileName))
            }
            return nil
        }

        if let existingFileName {
            let fileURL = imagesDirectoryURL.appendingPathComponent(existingFileName)
            guard let imageData = image.jpegData(compressionQuality: 0.9) else {
                throw StoreError.imageEncodingFailed
            }
            try imageData.write(to: fileURL, options: .atomic)
            return existingFileName
        }

        return try saveImage(image, id: id)
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

    private static func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    private static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

enum StoreError: Error {
    case imageEncodingFailed
}
