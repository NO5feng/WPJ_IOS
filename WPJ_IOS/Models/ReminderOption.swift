//
//  ReminderOption.swift
//  WPJ_IOS
//

import Foundation

enum ReminderOption: String, CaseIterable, Identifiable, Codable, Hashable {
    case sameDay
    case oneDayEarlier
    case oneWeekEarlier
    case oneMonthEarlier

    var id: String { rawValue }

    var title: String {
        switch self {
        case .sameDay:
            return "当天"
        case .oneDayEarlier:
            return "提前一天"
        case .oneWeekEarlier:
            return "提前一周"
        case .oneMonthEarlier:
            return "提前一个月"
        }
    }
}
