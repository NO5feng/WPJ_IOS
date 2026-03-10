//
//  RemindToggle.swift
//  WPJ_IOS
//

import SwiftUI

struct RemindToggle: View {
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.18)) { action() }
        } label: {
            ZStack(alignment: isOn ? .trailing : .leading) {
                Capsule()
                    .fill(isOn ? Color("Colors/pink") : Color("Colors/white"))
                    .frame(width: 58, height: 32)

                Circle()
                    .fill(isOn ? Color("Colors/white") : Color("Colors/yellow"))
                    .frame(width: 26, height: 26)
                    .padding(3)
            }
        }
        .buttonStyle(.plain)
    }
}
