//
//  AddItemViewModel.swift
//  WPJ_IOS
//

import Combine
import Foundation
import UIKit

final class AddItemViewModel: ObservableObject {
    let editingItemID: UUID?

    @Published var itemName = ""
    @Published var remindMe = false

    @Published var productionDate = Calendar.current.startOfDay(for: Date())
    @Published var expiryDate = Calendar.current.date(
        byAdding: .year,
        value: 1,
        to: Calendar.current.startOfDay(for: Date())
    ) ?? Calendar.current.startOfDay(for: Date())

    @Published var validityValue = 1
    @Published var validityUnit: ValidityUnit = .year
    @Published var remindOption: ReminderOption = .sameDay
    @Published var activeSheet: AddItemSheet?

    @Published var tempProductionYear = Calendar.current.component(.year, from: Date())
    @Published var tempProductionMonth = Calendar.current.component(.month, from: Date())
    @Published var tempProductionDay = Calendar.current.component(.day, from: Date())
    @Published var tempValidityValue = 1
    @Published var tempValidityUnit: ValidityUnit = .year
    @Published var tempRemindOption: ReminderOption = .sameDay

    @Published var selectedImage: UIImage?
    @Published var saveAlertMessage: String?

    init(item: StoredItem? = nil) {
        editingItemID = item?.id

        if let item {
            itemName = item.name
            remindMe = item.remindEnabled
            productionDate = Calendar.current.startOfDay(for: item.productionDate)
            expiryDate = Calendar.current.startOfDay(for: item.expiryDate)
            remindOption = item.remindOption ?? .sameDay
            tempRemindOption = remindOption

            let components = Calendar.current.dateComponents([.year, .month, .day], from: productionDate)
            tempProductionYear = components.year ?? tempProductionYear
            tempProductionMonth = components.month ?? tempProductionMonth
            tempProductionDay = components.day ?? tempProductionDay

            let diff = Self.inferValidityOffset(from: productionDate, to: expiryDate)
            validityValue = diff.value
            validityUnit = diff.unit
            tempValidityValue = diff.value
            tempValidityUnit = diff.unit

            if let imageFileName = item.imageFileName {
                selectedImage = ItemStore.loadImage(fileName: imageFileName)
            }
        }
    }

    var productionDateText: String {
        format(productionDate)
    }

    var expiryDateText: String {
        format(expiryDate)
    }

    var productionYearRange: ClosedRange<Int> {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (currentYear - 5)...(currentYear + 5)
    }

    var productionDayRange: ClosedRange<Int> {
        1...daysInMonth(year: tempProductionYear, month: tempProductionMonth)
    }

    func openProductionPicker() {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: productionDate)
        tempProductionYear = components.year ?? Calendar.current.component(.year, from: Date())
        tempProductionMonth = components.month ?? 1
        tempProductionDay = components.day ?? 1
        clampProductionDay()
        activeSheet = .productionDate
    }

    func openExpiryPicker() {
        tempValidityValue = validityValue
        tempValidityUnit = validityUnit
        activeSheet = .expiryOffset
    }

    func handleRemindToggleTap() {
        if remindMe {
            remindMe = false
            return
        }

        tempRemindOption = remindOption
        activeSheet = .remindTime
    }

    func confirmProductionDate() {
        productionDate = makeDate(year: tempProductionYear, month: tempProductionMonth, day: tempProductionDay)
        // 有效日期始终跟随生产日期与当前保质期偏移量重新计算。
        expiryDate = makeExpiryDate(base: productionDate, value: validityValue, unit: validityUnit)
        activeSheet = nil
    }

    func syncProductionDaySelection() {
        clampProductionDay()
    }

    func confirmExpiryOffset() {
        validityValue = tempValidityValue
        validityUnit = tempValidityUnit
        expiryDate = makeExpiryDate(base: productionDate, value: validityValue, unit: validityUnit)
        activeSheet = nil
    }

    func confirmRemindOption() {
        remindOption = tempRemindOption
        remindMe = true
        activeSheet = nil
    }

    func clampValidityValue(for unit: ValidityUnit) {
        let upper = validityRange(for: unit).upperBound
        if tempValidityValue > upper {
            tempValidityValue = upper
        }
    }

    func replaceSelectedImage(_ image: UIImage?) {
        selectedImage = image
    }

    func deleteSelectedImage() {
        selectedImage = nil
    }

    func saveItem() -> Bool {
        let trimmedName = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            saveAlertMessage = "请输入物品名称后再保存"
            return false
        }

        do {
            if let editingItemID {
                try ItemStore.update(
                    id: editingItemID,
                    name: trimmedName,
                    productionDate: productionDate,
                    expiryDate: expiryDate,
                    remindEnabled: remindMe,
                    remindOption: remindMe ? remindOption : nil,
                    image: selectedImage
                )
            } else {
                try ItemStore.save(
                    name: trimmedName,
                    productionDate: productionDate,
                    expiryDate: expiryDate,
                    remindEnabled: remindMe,
                    remindOption: remindMe ? remindOption : nil,
                    image: selectedImage
                )
            }
            return true
        } catch {
            saveAlertMessage = "保存失败，请重试"
            return false
        }
    }

    func clearSaveAlert() {
        saveAlertMessage = nil
    }

    private func makeExpiryDate(base: Date, value: Int, unit: ValidityUnit) -> Date {
        Calendar.current.date(byAdding: unit.component, value: value, to: base) ?? base
    }

    private func makeDate(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        let date = Calendar.current.date(from: components) ?? Date()
        return Calendar.current.startOfDay(for: date)
    }

    private func daysInMonth(year: Int, month: Int) -> Int {
        let components = DateComponents(year: year, month: month, day: 1)
        let date = Calendar.current.date(from: components) ?? Date()
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 30
    }

    private func clampProductionDay() {
        let maxDay = daysInMonth(year: tempProductionYear, month: tempProductionMonth)
        if tempProductionDay > maxDay {
            tempProductionDay = maxDay
        }
    }

    func validityRange(for unit: ValidityUnit) -> ClosedRange<Int> {
        switch unit {
        case .year, .month:
            return 1...12
        case .day:
            return 1...30
        }
    }

    private func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private static func inferValidityOffset(from productionDate: Date, to expiryDate: Date) -> (value: Int, unit: ValidityUnit) {
        let calendar = Calendar.current

        let yearDiff = calendar.dateComponents([.year], from: productionDate, to: expiryDate).year ?? 0
        if calendar.date(byAdding: .year, value: yearDiff, to: productionDate) == expiryDate, yearDiff > 0 {
            return (yearDiff, .year)
        }

        let monthDiff = calendar.dateComponents([.month], from: productionDate, to: expiryDate).month ?? 0
        if calendar.date(byAdding: .month, value: monthDiff, to: productionDate) == expiryDate, monthDiff > 0 {
            return (monthDiff, .month)
        }

        let dayDiff = calendar.dateComponents([.day], from: productionDate, to: expiryDate).day ?? 1
        return (max(dayDiff, 1), .day)
    }
}
