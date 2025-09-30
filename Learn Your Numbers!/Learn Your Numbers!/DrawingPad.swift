import SwiftUI

struct DrawingPad: View {
    @Binding var drawing: UIImage?
    @Binding var points: [CGPoint]

    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(10)
                .overlay(
                    GeometryReader { geometry in
                        Path { path in
                            for (i, point) in points.enumerated() {
                                if i == 0 {
                                    path.move(to: point)
                                } else {
                                    path.addLine(to: point)
                                }
                            }
                        }
                        .stroke(Color.black, lineWidth: 5)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0.1)
                                .onChanged { value in
                                    let location = value.location
                                    if location.x >= 0 && location.y >= 0 &&
                                        location.x < geometry.size.width &&
                                        location.y < geometry.size.height {
                                        points.append(location)
                                    }
                                }
                                .onEnded { _ in
                                    drawing = renderImage(from: points, size: geometry.size)
                                }
                        )
                    }
                )
        }
        .frame(width: 300, height: 300)
        .border(Color.gray, width: 2)
    }

    private func renderImage(from points: [CGPoint], size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            let path = UIBezierPath()
            for (i, point) in points.enumerated() {
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }

            UIColor.black.setStroke()
            path.lineWidth = 5
            path.stroke()
        }
    }
}
