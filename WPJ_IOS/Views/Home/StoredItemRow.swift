//
//  StoredItemRow.swift
//  WPJ_IOS
//

import SwiftUI
import UIKit

struct StoredItemRow: View {
    let item: StoredItem
    let isExpanded: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void
    @Namespace private var titleNamespace
    @State private var dragOffset: CGFloat = 0
    @State private var shakeOffset: CGFloat = 0

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

    private var cardOffset: CGFloat {
        min(max(dragOffset, -92), 92)
    }

    private var displayImage: UIImage? {
        guard let imageFileName = item.imageFileName else { return nil }
        return ItemStore.loadImage(fileName: imageFileName)
    }

    var body: some View {
        GeometryReader { proxy in
            let statusWidth = proxy.size.width * 0.30

            ZStack {
                if !isExpanded {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(cardOffset > 0 ? Color("Colors/white") : statusColor)
                        .overlay(alignment: cardOffset > 0 ? .leading : .trailing) {
                            HStack(spacing: 8) {
                                Image(systemName: cardOffset > 0 ? "trash" : "square.and.pencil")
                                    .font(.system(size: 16, weight: .semibold))

                                Text(cardOffset > 0 ? "删除" : "编辑")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundStyle(Color("Colors/black"))
                            .padding(.horizontal, 18)
                        }
                }

                Group {
                    if isExpanded {
                        expandedContent
                    } else {
                        compactContent(statusWidth: statusWidth)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color("Colors/white"))
                )
                .offset(x: cardOffset)
                .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .onTapGesture {
                    handleTap()
                }
                .gesture(
                    DragGesture(minimumDistance: 12)
                        .onChanged { value in
                            guard !isExpanded else { return }
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            guard !isExpanded else {
                                dragOffset = 0
                                return
                            }
                            withAnimation(.spring(response: 0.24, dampingFraction: 0.82)) {
                                if value.translation.width > 72 {
                                    onDelete()
                                } else if value.translation.width < -72 {
                                    onEdit()
                                }
                                dragOffset = 0
                            }
                        }
                )
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color("Colors/bg_grey"), lineWidth: 0.6)
            )
            .offset(x: shakeOffset)
            .animation(.spring(response: 0.34, dampingFraction: 0.84), value: isExpanded)
        }
    }

    @ViewBuilder
    private func compactContent(statusWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            HStack(spacing: 10) {
                Text(item.name)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color("Colors/black"))
                    .lineLimit(1)
                    .matchedGeometryEffect(id: "title-\(item.id)", in: titleNamespace)

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

    private var expandedContent: some View {
        VStack(spacing: 0) {
            Text(item.name)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(Color("Colors/black"))
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .padding(.top, 18)
                .matchedGeometryEffect(id: "title-\(item.id)", in: titleNamespace)

            Spacer(minLength: 12)

            Group {
                if let displayImage {
                    Image(uiImage: displayImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.clear
                }
            }
            .frame(width: 130, height: 130)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.bottom, 18)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func handleTap() {
        guard displayImage != nil else {
            playShake()
            return
        }

        onTap()
    }

    private func playShake() {
        guard !isExpanded else { return }

        dragOffset = 0

        let offsets: [CGFloat] = [-6, 5, -4, 2, 0]
        for (index, value) in offsets.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.045 * Double(index)) {
                withAnimation(.easeInOut(duration: 0.045)) {
                    shakeOffset = value
                }
            }
        }
    }
}
