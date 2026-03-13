//
//  AddItemView.swift
//  WPJ_IOS
//

import PhotosUI
import SwiftUI
import UIKit

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddItemViewModel

    @State private var showImageSourceDialog = false
    @State private var showPhotoPicker = false
    @State private var showCameraPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showDeleteImageDialog = false

    private let cardWidthRatio: CGFloat = 0.72
    private let cardTextColor = Color("Colors/black").opacity(0.72)

    init(item: StoredItem? = nil) {
        _viewModel = StateObject(wrappedValue: AddItemViewModel(item: item))
    }

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
                            if viewModel.saveItem() {
                                dismiss()
                            }
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
                        text: $viewModel.itemName,
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
                                viewModel.openProductionPicker()
                            } label: {
                                HStack {
                                    Text("生产日期")
                                        .foregroundStyle(cardTextColor)
                                    Spacer()
                                    Text(viewModel.productionDateText)
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
                                viewModel.openExpiryPicker()
                            } label: {
                                HStack {
                                    Text("有效日期")
                                        .foregroundStyle(cardTextColor)
                                    Spacer()
                                    Text(viewModel.expiryDateText)
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

                            if viewModel.remindMe {
                                Text(viewModel.remindOption.title)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color("Colors/grey2"))
                                    .padding(.trailing, 8)
                            }

                            RemindToggle(isOn: viewModel.remindMe) {
                                viewModel.handleRemindToggleTap()
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
                        height: viewModel.selectedImage == nil ? 50 : 220
                    )
                    .overlay {
                        if let selectedImage = viewModel.selectedImage {
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
                .animation(.easeInOut(duration: 0.2), value: viewModel.selectedImage != nil)
                .onTapGesture {
                    showImageSourceDialog = true
                }
                .onLongPressGesture(minimumDuration: 0.45) {
                    if viewModel.selectedImage != nil {
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
                viewModel.deleteSelectedImage()
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
                    viewModel.replaceSelectedImage(uiImage)
                }
            }
        }
        .sheet(isPresented: $showCameraPicker) {
            CameraPicker(image: $viewModel.selectedImage)
                .ignoresSafeArea()
        }
        .alert(
            "提示",
            isPresented: Binding(
                get: { viewModel.saveAlertMessage != nil },
                set: { showing in
                    if !showing { viewModel.clearSaveAlert() }
                }
            )
        ) {
            Button("知道了", role: .cancel) { }
        } message: {
            Text(viewModel.saveAlertMessage ?? "")
        }
        .sheet(item: $viewModel.activeSheet) { sheet in
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
                onCancel: { viewModel.activeSheet = nil },
                onConfirm: viewModel.confirmProductionDate
            )

            ProductionDatePickerContent(
                year: $viewModel.tempProductionYear,
                month: $viewModel.tempProductionMonth,
                day: $viewModel.tempProductionDay,
                yearRange: viewModel.productionYearRange,
                dayRange: viewModel.productionDayRange,
                onYearOrMonthChanged: viewModel.syncProductionDaySelection
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
                onCancel: { viewModel.activeSheet = nil },
                onConfirm: viewModel.confirmExpiryOffset
            )

            ExpiryOffsetPickerContent(
                value: $viewModel.tempValidityValue,
                unit: $viewModel.tempValidityUnit,
                onUnitChanged: viewModel.clampValidityValue(for:),
                rangeForUnit: viewModel.validityRange(for:)
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
                onCancel: { viewModel.activeSheet = nil },
                onConfirm: viewModel.confirmRemindOption
            )

            RemindTimePickerContent(option: $viewModel.tempRemindOption)

            Spacer(minLength: 0)
        }
        .presentationDetents([.height(390)])
        .presentationDragIndicator(.visible)
    }

}

#Preview {
    NavigationStack {
        AddItemView()
    }
}
