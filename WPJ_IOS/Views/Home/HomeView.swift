//
//  HomeView.swift
//  WPJ_IOS
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var items: [StoredItem] = []
    @State private var loadErrorMessage: String?
    @State private var pendingDeleteItem: StoredItem?
    @State private var editingItem: StoredItem?
    @State private var expandedItemID: UUID?

    private var filteredItems: [StoredItem] {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !keyword.isEmpty else { return items }
        return items.filter { $0.name.localizedCaseInsensitiveContains(keyword) }
    }

    var body: some View {
        GeometryReader { proxy in
            let topInset = max(proxy.safeAreaInsets.top, 8) + 6
            let panelTopGap: CGFloat = 16

            ZStack {
                AppTheme.pageBackground

                VStack(alignment: .leading, spacing: panelTopGap) {
                    Text("我的清单")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color("Colors/black"))
                        .padding(.leading, 20)

                    UnevenRoundedRectangle(
                        topLeadingRadius: 34,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 34
                    )
                    .fill(Color("Colors/milk_white"))
                    .overlay {
                        VStack(spacing: 16) {
                            HStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color("Colors/black").opacity(0.7))

                                TextField("搜索好物", text: $searchText)
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color("Colors/black"))
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 48)
                            .frame(width: min(proxy.size.width * 0.72, 300))
                            .background(AppTheme.pageBackground)
                            .clipShape(Capsule())
                            .frame(maxWidth: .infinity, alignment: .center)

                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVStack(spacing: 14) {
                                    if filteredItems.isEmpty {
                                        Text("暂无物品")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color("Colors/grey2"))
                                            .padding(.top, 12)
                                    } else {
                                        ForEach(filteredItems) { item in
                                            let isExpanded = expandedItemID == item.id

                                            StoredItemRow(
                                                item: item,
                                                isExpanded: isExpanded,
                                                onTap: {
                                                    withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) {
                                                        expandedItemID = isExpanded ? nil : item.id
                                                    }
                                                },
                                                onDelete: { pendingDeleteItem = item },
                                                onEdit: { editingItem = item }
                                            )
                                            .frame(
                                                width: min(proxy.size.width * 0.80, 320),
                                                height: isExpanded ? 220 : 68
                                            )
                                            .animation(.spring(response: 0.34, dampingFraction: 0.84), value: isExpanded)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 2)
                                .padding(.top, 4)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                            NavigationLink(destination: AddItemView()) {
                                Image("ic_add")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 58, height: 58)
                            }
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, max(proxy.safeAreaInsets.bottom, 16) + 8)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 18)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.top, topInset)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                if pendingDeleteItem != nil {
                    Color.black.opacity(0.16)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            pendingDeleteItem = nil
                        }

                    DeleteItemDialog(
                        onCancel: {
                            pendingDeleteItem = nil
                        },
                        onConfirm: deletePendingItem
                    )
                    .padding(.horizontal, 34)
                    .transition(.scale(scale: 0.96).combined(with: .opacity))
                }
            }
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.18), value: pendingDeleteItem != nil)
        }
        .onAppear {
            loadItems()
        }
        .navigationDestination(item: $editingItem) { item in
            AddItemView(item: item)
        }
        .alert(
            "读取失败",
            isPresented: Binding(
                get: { loadErrorMessage != nil },
                set: { showing in
                    if !showing { loadErrorMessage = nil }
                }
            )
        ) {
            Button("知道了", role: .cancel) {
                loadErrorMessage = nil
            }
        } message: {
            Text(loadErrorMessage ?? "")
        }
    }

    private func loadItems() {
        do {
            items = try ItemStore.loadAll()
            loadErrorMessage = nil
        } catch {
            loadErrorMessage = "本地数据读取失败，请稍后重试。"
        }
    }

    private func deletePendingItem() {
        guard let pendingDeleteItem else { return }

        do {
            try ItemStore.delete(id: pendingDeleteItem.id)
            items.removeAll { $0.id == pendingDeleteItem.id }
            if expandedItemID == pendingDeleteItem.id {
                expandedItemID = nil
            }
            self.pendingDeleteItem = nil
        } catch {
            self.pendingDeleteItem = nil
            loadErrorMessage = "删除失败，请稍后重试。"
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
