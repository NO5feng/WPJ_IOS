//
//  DeleteItemDialog.swift
//  WPJ_IOS
//

import SwiftUI

struct DeleteItemDialog: View {
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                Text("删除物品？")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color("Colors/black"))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                Text("删除后将无法恢复。")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color("Colors/grey2"))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 26)
            .padding(.horizontal, 24)
            .padding(.bottom, 22)

            HStack(spacing: 12) {
                Button(action: onCancel) {
                    Text("取消")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color("Colors/white"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(Color("Colors/pink"))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)

                Button(action: onConfirm) {
                    Text("删除")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color("Colors/pink"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(Color.clear)
                        .overlay {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color("Colors/pink"), lineWidth: 1.5)
                        }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: 320)
        .background(Color("Colors/milk_white"))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color("Colors/white").opacity(0.9), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.08), radius: 18, y: 8)
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.1).ignoresSafeArea()

        DeleteItemDialog(
            onCancel: { },
            onConfirm: { }
        )
        .padding(.horizontal, 34)
    }
}
