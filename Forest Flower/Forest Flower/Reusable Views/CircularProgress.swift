//
//  CircularProgress.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 16/06/23.
//

import SwiftUI

struct CircularProgress: View {

    @Binding
    var progress: CGFloat

    let foregroundThickness: CGFloat
    let backgroundThickness: CGFloat

    let colors: (background: [Color], progress: [Color])

    var body: some View {
        Circle()
            .stroke(
                LinearGradient(colors: colors.background, startPoint: .top, endPoint: .bottom), style: .init(lineWidth: backgroundThickness)
            )
            .overlay {
                Circle()
                    .trim(from: 0, to: min(1, progress))
                    .stroke(
                        LinearGradient(colors: colors.progress, startPoint: .top, endPoint: .bottom), style: .init(lineWidth: foregroundThickness)
                    )
                    .rotationEffect(Angle(degrees: 270)) // It says start from top middle.
                    .animation(.easeIn(duration: progress * 2), value: progress)
            }
    }
}
