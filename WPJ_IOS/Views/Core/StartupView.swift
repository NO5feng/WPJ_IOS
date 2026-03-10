//
//  StartupView.swift
//  WPJ_IOS
//

import SwiftUI

struct StartupView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer(minLength: proxy.size.height * 0.16)

                Image("Brand/logo_primary")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(proxy.size.width * 0.58, 260))

                Spacer(minLength: proxy.size.height * 0.5)

                Image("Brand/slogan_primary")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(proxy.size.width * 0.52, 220))

                Spacer()
            }
            .appPageBackground()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    StartupView()
}
