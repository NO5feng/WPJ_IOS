//
//  AddItemPickerViews.swift
//  WPJ_IOS
//

import SwiftUI

struct AddItemSheetHeader: View {
    let title: String
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        HStack {
            Button("取消", action: onCancel)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color("Colors/grey2"))

            Spacer()

            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color("Colors/black"))

            Spacer()

            Button("确定", action: onConfirm)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color("Colors/pink"))
        }
        .padding(.horizontal, 40)
        .padding(.top, 16)
        .padding(.bottom, 80)
    }
}

struct ProductionDatePickerContent: View {
    @Binding var year: Int
    @Binding var month: Int
    @Binding var day: Int
    let yearRange: ClosedRange<Int>
    let dayRange: ClosedRange<Int>
    let onYearOrMonthChanged: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Picker("年", selection: $year) {
                ForEach(Array(yearRange), id: \.self) { value in
                    Text("\(value)年")
                        .foregroundStyle(value == year ? Color("Colors/pink") : Color("Colors/grey2"))
                        .tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .clipped()

            Picker("月", selection: $month) {
                ForEach(1...12, id: \.self) { value in
                    Text("\(value)月")
                        .foregroundStyle(value == month ? Color("Colors/pink") : Color("Colors/grey2"))
                        .tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .clipped()

            Picker("日", selection: $day) {
                ForEach(Array(dayRange), id: \.self) { value in
                    Text("\(value)日")
                        .foregroundStyle(value == day ? Color("Colors/pink") : Color("Colors/grey2"))
                        .tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .clipped()
        }
        .font(.system(size: 22, weight: .medium))
        .padding(.top, 6)
        .onChange(of: year) { _, _ in onYearOrMonthChanged() }
        .onChange(of: month) { _, _ in onYearOrMonthChanged() }
    }
}

struct ExpiryOffsetPickerContent: View {
    @Binding var value: Int
    @Binding var unit: ValidityUnit
    let onUnitChanged: (ValidityUnit) -> Void
    let rangeForUnit: (ValidityUnit) -> ClosedRange<Int>

    var body: some View {
        HStack(spacing: 0) {
            Picker("数值", selection: $value) {
                ForEach(rangeForUnit(unit), id: \.self) { number in
                    Text("\(number)")
                        .foregroundStyle(number == value ? Color("Colors/pink") : Color("Colors/grey2"))
                        .tag(number)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
            .frame(height: 126)
            .clipped()

            Picker("单位", selection: $unit) {
                ForEach(ValidityUnit.allCases) { option in
                    Text(option.title)
                        .foregroundStyle(option == unit ? Color("Colors/pink") : Color("Colors/grey2"))
                        .tag(option)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
            .frame(height: 126)
            .clipped()
        }
        .font(.system(size: 22, weight: .medium))
        .padding(.top, 6)
        .onChange(of: unit) { _, newValue in onUnitChanged(newValue) }
    }
}

struct RemindTimePickerContent: View {
    @Binding var option: ReminderOption

    var body: some View {
        Picker("提醒时间", selection: $option) {
            ForEach(ReminderOption.allCases) { value in
                Text(value.title)
                    .foregroundStyle(value == option ? Color("Colors/pink") : Color("Colors/grey2"))
                    .tag(value)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 126)
        .clipped()
        .font(.system(size: 22, weight: .medium))
        .padding(.top, 6)
    }
}
