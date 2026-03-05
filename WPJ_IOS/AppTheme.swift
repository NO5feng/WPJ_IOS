//
//  AppTheme.swift
//  WPJ_IOS
//

import SwiftUI

enum AppTheme {
    static let pageBackground = Color("Colors/yellow")
}

private struct AppPageBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppTheme.pageBackground)
    }
}

extension View {
    // 所有页面统一调用这个修饰器，避免每页重复写背景逻辑。
    func appPageBackground() -> some View {
        modifier(AppPageBackgroundModifier())
    }
}
