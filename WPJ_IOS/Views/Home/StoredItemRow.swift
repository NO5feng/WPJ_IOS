//
//  StoredItemRow.swift
//  WPJ_IOS
//

import SwiftUI

struct StoredItemRow: View {
    let item: StoredItem

    private var daysDiff: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let expiry = calendar.startOfDay(for: item.expiryDate)
        return calendar.dateComponents([.day], from: today, to: expiry).day ?? 0
    }

    private var isExpired: Bool {
        daysDiff < 0
    }

    private var statusColor: Color {
        isExpired ? Color("Colors/yellow") : Color("Colors/pink")
    }

    private var statusTextColor: Color {
        Color("Colors/black")
    }

    private var topLabel: String {
        isExpired ? "已过期" : "\(daysDiff)"
    }

    private var bottomLabel: String {
        isExpired ? "\(abs(daysDiff))天" : "天"
    }

    var body: some View {
        GeometryReader { proxy in
            let statusWidth = proxy.size.width * 0.30

            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color("Colors/white"))

                HStack(spacing: 0) {
                    HStack(spacing: 10) {
                        Text(item.name)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color("Colors/black"))
                            .lineLimit(1)

                        Spacer(minLength: 8)

                        Image("ic_more")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.leading, 14)
                    .padding(.trailing, 6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 16,
                        topTrailingRadius: 16
                    )
                    .fill(statusColor)
                    .frame(width: statusWidth)
                    .overlay {
                        VStack(spacing: 2) {
                            Text(topLabel)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(statusTextColor)

                            Text(bottomLabel)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(statusTextColor.opacity(0.9))
                        }
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color("Colors/bg_grey"), lineWidth: 0.6)
            )
        }
    }
}
