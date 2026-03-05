//
//  AddItemView.swift
//  WPJ_IOS
//

import SwiftUI

struct AddItemView: View {
    var body: some View {
        ZStack {
            AppTheme.pageBackground.ignoresSafeArea()
            Text("添加内容")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color("Colors/black"))
        }
        .navigationTitle("添加内容")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AddItemView()
    }
}
