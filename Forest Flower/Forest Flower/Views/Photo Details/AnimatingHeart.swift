//
//  AnimatingHeart.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 02/07/23.
//

import SwiftUI

struct AnimatingHeart: View {

    let animationDuration: Double = 2

    @Binding
    var isLiked: Bool

    var body: some View {
        self.likeButton
    }

    var heartImage: some View {
        (isLiked ? SystemImage.heartFilled : SystemImage.heart)
            .foregroundColor(.red)
            .setFont(style: .headerLarge)
    }

    let heartFrameSize: CGFloat = 45

    var likeButton: some View {
        ZStack {
            GeometryReader { geo in
                let local = geo.frame(in: .local)
                self.heartImage
                    .shadow(color: .black, radius: 5, x: 1, y: 1)
                    .opacity(isLiked ? 0 : 1)
                    .scaleEffect(.init(width: isLiked ? 4 : 1, height: isLiked ? 4 : 1))
                    .modifier(
                        Moving(portion: isLiked ? 1 : 0,
                               path: self.path(in: .init(origin: .init(x: local.maxX, y: 0), size: local.size)),
                               start: .init(x: local.maxX, y: local.maxY))
                    )
                    .animation(isLiked ? .easeOut(duration: animationDuration) : nil, // to unlike we do not animate heart, Thus nil.
                               value: isLiked ? animationDuration : 0)
                    .overlay {
                        self.heartImage
                            .shadow(color: isLiked ? .black : .clear, radius: 5,
                                    x: isLiked ? 0 : 1,
                                    y: isLiked ? 0 : 1)
                            .offset(x: local.maxX - heartFrameSize/2, y: local.maxY - heartFrameSize/2)
                    }
                    .frame(width: heartFrameSize, height: heartFrameSize)
            }
        }
    }

    private func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .init(x: rect.maxX/2, y: rect.maxY))
        path.addCurve(to: .init(x: rect.maxX/2, y: rect.minY),
                      control1: .init(x: 200, y: rect.maxY * 0.5),
                      control2: .init(x: 230, y: rect.maxY * 0.7))
        return path
    }
}

struct Moving: Animatable, ViewModifier {

    var portion : CGFloat
    let path : Path
    let start: CGPoint

    var animatableData: CGFloat {
        get { portion }
        set { portion = newValue }
    }

    func body(content: Content) -> some View {
        content
            .position(
                path.trimmedPath(from: 0, to: portion).currentPoint ?? start
            )
    }
}

struct NewPlay_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AnimatingHeart(isLiked: .constant(true))
        }
        .padding(50)
        .frame(width: 400, height: 400)
        .background(.yellow.opacity(0.5))
    }
}
