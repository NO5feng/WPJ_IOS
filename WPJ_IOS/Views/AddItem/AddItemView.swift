//
//  AddItemView.swift
//  WPJ_IOS
//

import PhotosUI
import SwiftUI
import UIKit

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var itemName = ""
    @State private var remindMe = false

    @State private var productionDate = Calendar.current.startOfDay(for: Date())
    @State private var expiryDate = Calendar.current.date(
        byAdding: .year,
        value: 1,
        to: Calendar.current.startOfDay(for: Date())
    ) ?? Calendar.current.startOfDay(for: Date())

    @State private var validityValue = 1
    @State private var validityUnit: ValidityUnit = .year

    @State private var remindOption: ReminderOption = .sameDay
    @State private var activeSheet: AddItemSheet?
    @State private var tempProductionYear = Calendar.current.component(.year, from: Date())
    @State private var tempProductionMonth = Calendar.current.component(.month, from: Date())
    @State private var tempProductionDay = Calendar.current.component(.day, from: Date())
    @State private var tempValidityValue = 1
    @State private var tempValidityUnit: ValidityUnit = .year
    @State private var tempRemindOption: ReminderOption = .sameDay
    @State private var showImageSourceDialog = false
    @State private var showPhotoPicker = false
    @State private var showCameraPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDeleteImageDialog = false
    @State private var showSaveAlert = false
    @State private var saveAlertMessage = ""

    private let cardWidthRatio: CGFloat = 0.72
    private let cardTextColor = Color("Colors/black").opacity(0.72)

    private var productionDateText: String {
        Self.dateFormatter.string(from: productionDate)
    }

    private var expiryDateText: String {
        Self.dateFormatter.string(from: expiryDate)
    }

    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }

    private var productionYearRange: ClosedRange<Int> {
        (currentYear - 5)...(currentYear + 5)
    }

    private var productionDayRange: ClosedRange<Int> {
        1...daysInMonth(year: tempProductionYear, month: tempProductionMonth)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                ZStack {
                    Text("新增")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color("Colors/black"))

                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Color("Colors/black"))
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.plain)

                        Spacer()

                        Button {
                            saveItemAndDismiss()
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Color("Colors/black"))
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, max(proxy.safeAreaInsets.top, 0) + 8)
                .padding(.horizontal, 45)
                .padding(.bottom, 10)

                VStack(spacing: 8) {
                    TextField(
                        "",
                        text: $itemName,
                        prompt: Text("请输入物品名称")
                            .foregroundStyle(Color("Colors/black").opacity(0.75))
                    )
                    .padding(.leading, 10)
                    .font(.system(size: 18))
                    .foregroundStyle(Color("Colors/black"))
                    .textFieldStyle(.plain)

                    Rectangle()
                        .fill(Color("Colors/black"))
                        .frame(height: 1)
                }
                .frame(width: min(proxy.size.width * cardWidthRatio, 360))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 30)

                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color("Colors/yellow"))
                    .frame(width: min(proxy.size.width * cardWidthRatio, 360), height: 124)
                    .overlay {
                        VStack(spacing: 0) {
                            Button {
                                openProductionPicker()
                            } label: {
                                HStack {
                                    Text("生产日期")
                                        .foregroundStyle(cardTextColor)
                                    Spacer()
                                    Text(productionDateText)
                                        .foregroundStyle(cardTextColor)
                                }
                                .font(.system(size: 16, weight: .medium))
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .buttonStyle(.plain)

                            Rectangle()
                                .fill(Color("Colors/milk_white"))
                                .frame(height: 1)
                                .padding(.horizontal, 10)

                            Button {
                                openExpiryPicker()
                            } label: {
                                HStack {
                                    Text("有效日期")
                                        .foregroundStyle(cardTextColor)
                                    Spacer()
                                    Text(expiryDateText)
                                        .foregroundStyle(cardTextColor)
                                }
                                .font(.system(size: 16, weight: .medium))
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 45)

                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color("Colors/yellow"))
                    .frame(width: min(proxy.size.width * cardWidthRatio, 360), height: 76)
                    .overlay {
                        HStack {
                            Text("提醒我")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(cardTextColor)

                            Spacer()

                            if remindMe {
                                Text(remindOption.title)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color("Colors/grey2"))
                                    .padding(.trailing, 8)
                            }

                            RemindToggle(isOn: remindMe) {
                                handleRemindToggleTap()
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 30)

                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color("Colors/yellow"))
                    .frame(
                        width: min(proxy.size.width * cardWidthRatio, 360),
                        height: selectedImage == nil ? 50 : 220
                    )
                    .overlay {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 20)
                        } else {
                            HStack(spacing: 14) {
                                Image(systemName: "photo")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(Color("Colors/white"))

                                Text("插入物品图片")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(cardTextColor)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 30)
                .animation(.easeInOut(duration: 0.2), value: selectedImage != nil)
                .onTapGesture {
                    showImageSourceDialog = true
                }
                .onLongPressGesture(minimumDuration: 0.45) {
                    if selectedImage != nil {
                        showDeleteImageDialog = true
                    }
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Colors/milk_white"))
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .confirmationDialog("选择图片来源", isPresented: $showImageSourceDialog, titleVisibility: .visible) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button {
                    showCameraPicker = true
                } label: {
                    Label("使用相机", systemImage: "camera")
                }
            }

            Button {
                showPhotoPicker = true
            } label: {
                Label("从相册中选择", systemImage: "photo.on.rectangle")
            }

            Button("取消", role: .cancel) { }
        }
        .confirmationDialog("删除图片？", isPresented: $showDeleteImageDialog, titleVisibility: .visible) {
            Button("删除", role: .destructive) {
                selectedImage = nil
                selectedPhotoItem = nil
            }
            Button("取消", role: .cancel) { }
        } message: {
            Text("长按图片可删除当前内容")
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhotoItem,
            matching: .images
        )
        .onChange(of: selectedPhotoItem) { _, newValue in
            Task {
                guard let data = try? await newValue?.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: data) else { return }
                await MainActor.run {
                    selectedImage = uiImage
                }
            }
        }
        .sheet(isPresented: $showCameraPicker) {
            CameraPicker(image: $selectedImage)
                .ignoresSafeArea()
        }
        .alert("提示", isPresented: $showSaveAlert) {
            Button("知道了", role: .cancel) { }
        } message: {
            Text(saveAlertMessage)
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .productionDate:
                productionDateSheet
            case .expiryOffset:
                expiryOffsetSheet
            case .remindTime:
                remindTimeSheet
            }
        }
    }

    private var productionDateSheet: some View {
        VStack(spacing: 0) {
            AddItemSheetHeader(
                title: "生产日期",
                onCancel: { activeSheet = nil },
                onConfirm: confirmProductionDate
            )

            ProductionDatePickerContent(
                year: $tempProductionYear,
                month: $tempProductionMonth,
                day: $tempProductionDay,
                yearRange: productionYearRange,
                dayRange: productionDayRange,
                onYearOrMonthChanged: clampProductionDay
            )

            Spacer(minLength: 0)
        }
        .presentationDetents([.height(390)])
        .presentationDragIndicator(.visible)
    }

    private var expiryOffsetSheet: some View {
        VStack(spacing: 0) {
            AddItemSheetHeader(
                title: "保质期止",
                onCancel: { activeSheet = nil },
                onConfirm: confirmExpiryOffset
            )

            ExpiryOffsetPickerContent(
                value: $tempValidityValue,
                unit: $tempValidityUnit,
                onUnitChanged: { newUnit in
                    let upper = validityRange(for: newUnit).upperBound
                    if tempValidityValue > upper {
                        tempValidityValue = upper
                    }
                },
                rangeForUnit: validityRange(for:)
            )

            Spacer(minLength: 0)
        }
        .presentationDetents([.height(390)])
        .presentationDragIndicator(.visible)
    }

    private var remindTimeSheet: some View {
        VStack(spacing: 0) {
            AddItemSheetHeader(
                title: "选择提醒时间",
                onCancel: { activeSheet = nil },
                onConfirm: confirmRemindOption
            )

            RemindTimePickerContent(option: $tempRemindOption)

            Spacer(minLength: 0)
        }
        .presentationDetents([.height(390)])
        .presentationDragIndicator(.visible)
    }

    private func openProductionPicker() {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: productionDate)
        tempProductionYear = components.year ?? currentYear
        tempProductionMonth = components.month ?? 1
        tempProductionDay = components.day ?? 1
        clampProductionDay()
        activeSheet = .productionDate
    }

    private func openExpiryPicker() {
        tempValidityValue = validityValue
        tempValidityUnit = validityUnit
        activeSheet = .expiryOffset
    }

    private func handleRemindToggleTap() {
        if remindMe {
            remindMe = false
            return
        }

        tempRemindOption = remindOption
        activeSheet = .remindTime
    }

    private func confirmProductionDate() {
        productionDate = makeDate(year: tempProductionYear, month: tempProductionMonth, day: tempProductionDay)
        // 有效日期始终基于生产日期 + 当前有效期偏移量计算。
        expiryDate = makeExpiryDate(base: productionDate, value: validityValue, unit: validityUnit)
        activeSheet = nil
    }

    private func confirmExpiryOffset() {
        validityValue = tempValidityValue
        validityUnit = tempValidityUnit
        expiryDate = makeExpiryDate(base: productionDate, value: validityValue, unit: validityUnit)
        activeSheet = nil
    }

    private func confirmRemindOption() {
        remindOption = tempRemindOption
        remindMe = true
        activeSheet = nil
    }

    private func saveItemAndDismiss() {
        let trimmedName = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            saveAlertMessage = "请输入物品名称后再保存"
            showSaveAlert = true
            return
        }

        do {
            try ItemStore.save(
                name: trimmedName,
                productionDate: productionDate,
                expiryDate: expiryDate,
                remindEnabled: remindMe,
                remindOption: remindMe ? remindOption : nil,
                image: selectedImage
            )
            dismiss()
        } catch {
            saveAlertMessage = "保存失败，请重试"
            showSaveAlert = true
        }
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

    private func validityRange(for unit: ValidityUnit) -> ClosedRange<Int> {
        switch unit {
        case .year, .month:
            return 1...12
        case .day:
            return 1...30
        }
    }
}

#Preview {
    NavigationStack {
        AddItemView()
    }
}
