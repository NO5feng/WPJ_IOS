//
//  StoredItem.swift
//  WPJ_IOS
//

import Foundation

struct StoredItem: Codable, Identifiable {
    let id: UUID
    let name: String
    let productionDate: Date
    let expiryDate: Date
    let remindEnabled: Bool
    let remindOption: ReminderOption?
    let imageFileName: String?
    let createdAt: Date
}
