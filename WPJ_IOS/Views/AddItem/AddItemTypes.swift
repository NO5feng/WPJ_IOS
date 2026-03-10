//
//  AddItemTypes.swift
//  WPJ_IOS
//

import Foundation

enum AddItemSheet: String, Identifiable {
    case productionDate
    case expiryOffset
    case remindTime

    var id: String { rawValue }
}

enum ValidityUnit: CaseIterable, Identifiable {
    case year
    case month
    case day

    var id: String { title }

    var title: String {
        switch self {
        case .year:
            return "年"
        case .month:
            return "月"
        case .day:
            return "日"
        }
    }

    var component: Calendar.Component {
        switch self {
        case .year:
            return .year
        case .month:
            return .month
        case .day:
            return .day
        }
    }
}
