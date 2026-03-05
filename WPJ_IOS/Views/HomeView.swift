//
//  HomeView.swift
//  WPJ_IOS
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""

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
                                VStack(spacing: 0) {
                                    EmptyView()
                                }
                                .frame(maxWidth: .infinity)
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
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
