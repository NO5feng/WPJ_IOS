//
//  HeartRainOverlay.swift
//  WPJ_IOS
//

import SwiftUI

private struct HeartParticle: Identifiable {
    let id = UUID()
    let x: CGFloat
    let size: CGFloat
    let drift: CGFloat
    let rotation: Double
    let delay: Double
    let duration: Double
    let opacity: Double
    let scale: CGFloat
}

struct HeartRainOverlay: View {
    let onFinished: () -> Void

    @State private var particles: [HeartParticle] = []
    @State private var animateParticles = false
    @State private var overlayOpacity = 1.0

    private let animationDuration: Double = 2.8

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color("Colors/milk_white")
                    .opacity(0.08)
                    .ignoresSafeArea()

                ForEach(particles) { particle in
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: particle.size, height: particle.size)
                        .foregroundStyle(Color("Colors/pink"))
                        .rotationEffect(.degrees(animateParticles ? particle.rotation : 0))
                        .scaleEffect(animateParticles ? particle.scale : 0.92)
                        .opacity(animateParticles ? particle.opacity : 0)
                        .position(
                            x: animateParticles ? particle.x + particle.drift : particle.x,
                            y: animateParticles ? proxy.size.height + particle.size * 1.6 : -particle.size * 1.8
                        )
                        .animation(
                            .timingCurve(0.22, 0.8, 0.26, 1, duration: particle.duration)
                                .delay(particle.delay),
                            value: animateParticles
                        )
                }
            }
            .opacity(overlayOpacity)
            .contentShape(Rectangle())
            .onTapGesture { }
            .onAppear {
                configureParticles(for: proxy.size)
                startAnimation()
            }
        }
        .ignoresSafeArea()
    }

    private func configureParticles(for size: CGSize) {
        let width = max(size.width, 1)

        particles = (0..<96).map { index in
            let progress = Double(index) / 95.0

            return HeartParticle(
                x: CGFloat.random(in: 18...(width - 18)),
                size: CGFloat.random(in: 18...34),
                drift: CGFloat.random(in: -26...26),
                rotation: Double.random(in: -28...28),
                delay: progress * 1.25 + Double.random(in: 0...0.55),
                duration: Double.random(in: 1.45...2.4),
                opacity: Double.random(in: 0.72...1),
                scale: CGFloat.random(in: 0.92...1.18)
            )
        }
    }

    private func startAnimation() {
        DispatchQueue.main.async {
            animateParticles = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration - 0.35) {
            withAnimation(.easeOut(duration: 0.28)) {
                overlayOpacity = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            onFinished()
        }
    }
}

#Preview {
    HeartRainOverlay {
    }
}
