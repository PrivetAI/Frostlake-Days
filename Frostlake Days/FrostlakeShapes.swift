import SwiftUI

// MARK: - Hexagon
struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = rect.midX
        let cy = rect.midY
        let r = min(w, h) / 2
        for i in 0..<6 {
            let angle = Double(i) * Double.pi / 3.0 - Double.pi / 2.0
            let x = cx + r * CGFloat(cos(angle))
            let y = cy + r * CGFloat(sin(angle))
            if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
            else { path.addLine(to: CGPoint(x: x, y: y)) }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Snowflake
struct SnowflakeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cx = rect.midX
        let cy = rect.midY
        let r = min(rect.width, rect.height) / 2
        for i in 0..<6 {
            let angle = Double(i) * Double.pi / 3.0
            let x1 = cx + CGFloat(cos(angle)) * r
            let y1 = cy + CGFloat(sin(angle)) * r
            path.move(to: CGPoint(x: cx, y: cy))
            path.addLine(to: CGPoint(x: x1, y: y1))
            // little branches
            let bAngle1 = angle + Double.pi / 6.0
            let bAngle2 = angle - Double.pi / 6.0
            let mx = cx + CGFloat(cos(angle)) * r * 0.6
            let my = cy + CGFloat(sin(angle)) * r * 0.6
            path.move(to: CGPoint(x: mx, y: my))
            path.addLine(to: CGPoint(x: mx + CGFloat(cos(bAngle1)) * r * 0.25,
                                     y: my + CGFloat(sin(bAngle1)) * r * 0.25))
            path.move(to: CGPoint(x: mx, y: my))
            path.addLine(to: CGPoint(x: mx + CGFloat(cos(bAngle2)) * r * 0.25,
                                     y: my + CGFloat(sin(bAngle2)) * r * 0.25))
        }
        return path
    }
}

// MARK: - Cabin (small cottage silhouette)
struct CabinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let bodyTop = h * 0.42
        path.move(to: CGPoint(x: w * 0.1, y: h * 0.95))
        path.addLine(to: CGPoint(x: w * 0.1, y: bodyTop))
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.12))
        path.addLine(to: CGPoint(x: w * 0.9, y: bodyTop))
        path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.95))
        path.closeSubpath()
        // door
        path.move(to: CGPoint(x: w * 0.42, y: h * 0.95))
        path.addLine(to: CGPoint(x: w * 0.42, y: h * 0.65))
        path.addLine(to: CGPoint(x: w * 0.58, y: h * 0.65))
        path.addLine(to: CGPoint(x: w * 0.58, y: h * 0.95))
        // chimney
        path.move(to: CGPoint(x: w * 0.72, y: h * 0.30))
        path.addLine(to: CGPoint(x: w * 0.72, y: h * 0.08))
        path.addLine(to: CGPoint(x: w * 0.84, y: h * 0.08))
        path.addLine(to: CGPoint(x: w * 0.84, y: h * 0.36))
        return path
    }
}

// MARK: - Lake hole (ice with hole)
struct LakeHoleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Outer ice patch
        path.addEllipse(in: rect.insetBy(dx: rect.width * 0.04, dy: rect.height * 0.18))
        // Inner hole
        let inner = rect.insetBy(dx: rect.width * 0.30, dy: rect.height * 0.32)
        path.addEllipse(in: inner)
        return path
    }
}

// MARK: - Pier silhouette
struct PierShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: w * 0.05, y: h * 0.55))
        path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.55))
        path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.65))
        path.addLine(to: CGPoint(x: w * 0.05, y: h * 0.65))
        path.closeSubpath()
        // posts
        for i in 0..<4 {
            let x = w * (0.15 + CGFloat(i) * 0.18)
            path.move(to: CGPoint(x: x, y: h * 0.65))
            path.addLine(to: CGPoint(x: x, y: h * 0.95))
        }
        // pole rod
        path.move(to: CGPoint(x: w * 0.85, y: h * 0.55))
        path.addLine(to: CGPoint(x: w * 0.97, y: h * 0.10))
        return path
    }
}

// MARK: - Fish silhouette
struct FishShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        // body
        path.move(to: CGPoint(x: w * 0.08, y: h * 0.5))
        path.addQuadCurve(to: CGPoint(x: w * 0.7, y: h * 0.15),
                          control: CGPoint(x: w * 0.4, y: h * 0.0))
        path.addQuadCurve(to: CGPoint(x: w * 0.7, y: h * 0.85),
                          control: CGPoint(x: w * 1.05, y: h * 0.5))
        path.addQuadCurve(to: CGPoint(x: w * 0.08, y: h * 0.5),
                          control: CGPoint(x: w * 0.4, y: h * 1.0))
        path.closeSubpath()
        // tail
        path.move(to: CGPoint(x: w * 0.7, y: h * 0.35))
        path.addLine(to: CGPoint(x: w * 0.98, y: h * 0.15))
        path.addLine(to: CGPoint(x: w * 0.98, y: h * 0.85))
        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.65))
        path.closeSubpath()
        // eye
        path.addEllipse(in: CGRect(x: w * 0.20, y: h * 0.42, width: w * 0.06, height: h * 0.10))
        return path
    }
}

// MARK: - Coin
struct CoinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: rect.insetBy(dx: rect.width * 0.05, dy: rect.height * 0.05))
        path.addEllipse(in: rect.insetBy(dx: rect.width * 0.18, dy: rect.height * 0.18))
        let cx = rect.midX
        let cy = rect.midY
        path.move(to: CGPoint(x: cx - rect.width * 0.10, y: cy))
        path.addLine(to: CGPoint(x: cx + rect.width * 0.10, y: cy))
        path.move(to: CGPoint(x: cx, y: cy - rect.height * 0.10))
        path.addLine(to: CGPoint(x: cx, y: cy + rect.height * 0.10))
        return path
    }
}

// MARK: - Heart (geometric)
struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.95))
        path.addLine(to: CGPoint(x: w * 0.05, y: h * 0.5))
        path.addLine(to: CGPoint(x: w * 0.25, y: h * 0.12))
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.35))
        path.addLine(to: CGPoint(x: w * 0.75, y: h * 0.12))
        path.addLine(to: CGPoint(x: w * 0.95, y: h * 0.5))
        path.closeSubpath()
        return path
    }
}

// MARK: - Star
struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cx = rect.midX
        let cy = rect.midY
        let outer = min(rect.width, rect.height) / 2
        let inner = outer * 0.45
        for i in 0..<10 {
            let r = i.isMultiple(of: 2) ? outer : inner
            let angle = Double(i) * Double.pi / 5.0 - Double.pi / 2.0
            let x = cx + CGFloat(cos(angle)) * r
            let y = cy + CGFloat(sin(angle)) * r
            if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
            else { path.addLine(to: CGPoint(x: x, y: y)) }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Book
struct BookShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: w * 0.1, y: h * 0.15))
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.2))
        path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.15))
        path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.85))
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.9))
        path.addLine(to: CGPoint(x: w * 0.1, y: h * 0.85))
        path.closeSubpath()
        // spine line
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.2))
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.9))
        return path
    }
}

// MARK: - Cooking pot
struct PotShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        // body
        path.move(to: CGPoint(x: w * 0.1, y: h * 0.35))
        path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.35))
        path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.9))
        path.addLine(to: CGPoint(x: w * 0.15, y: h * 0.9))
        path.closeSubpath()
        // handles
        path.move(to: CGPoint(x: w * 0.1, y: h * 0.45))
        path.addLine(to: CGPoint(x: w * 0.02, y: h * 0.5))
        path.move(to: CGPoint(x: w * 0.9, y: h * 0.45))
        path.addLine(to: CGPoint(x: w * 0.98, y: h * 0.5))
        // steam
        path.move(to: CGPoint(x: w * 0.3, y: h * 0.25))
        path.addQuadCurve(to: CGPoint(x: w * 0.4, y: h * 0.05),
                          control: CGPoint(x: w * 0.25, y: h * 0.15))
        path.move(to: CGPoint(x: w * 0.55, y: h * 0.25))
        path.addQuadCurve(to: CGPoint(x: w * 0.65, y: h * 0.05),
                          control: CGPoint(x: w * 0.5, y: h * 0.15))
        return path
    }
}

// MARK: - Compass
struct CompassShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cx = rect.midX
        let cy = rect.midY
        let r = min(rect.width, rect.height) / 2 - 2
        path.addEllipse(in: CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r))
        // arrow
        path.move(to: CGPoint(x: cx, y: cy - r * 0.7))
        path.addLine(to: CGPoint(x: cx + r * 0.18, y: cy))
        path.addLine(to: CGPoint(x: cx, y: cy + r * 0.7))
        path.addLine(to: CGPoint(x: cx - r * 0.18, y: cy))
        path.closeSubpath()
        return path
    }
}

// MARK: - Path arrow
struct PathArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: w * 0.15, y: h * 0.50))
        path.addLine(to: CGPoint(x: w * 0.75, y: h * 0.50))
        // arrow head
        path.move(to: CGPoint(x: w * 0.55, y: h * 0.25))
        path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.50))
        path.addLine(to: CGPoint(x: w * 0.55, y: h * 0.75))
        return path
    }
}

// MARK: - Lantern
struct LanternShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        // top hook
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.05))
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.18))
        // top cap
        path.move(to: CGPoint(x: w * 0.32, y: h * 0.22))
        path.addLine(to: CGPoint(x: w * 0.68, y: h * 0.22))
        // body
        path.move(to: CGPoint(x: w * 0.32, y: h * 0.22))
        path.addLine(to: CGPoint(x: w * 0.28, y: h * 0.75))
        path.addLine(to: CGPoint(x: w * 0.72, y: h * 0.75))
        path.addLine(to: CGPoint(x: w * 0.68, y: h * 0.22))
        path.closeSubpath()
        // base
        path.move(to: CGPoint(x: w * 0.25, y: h * 0.80))
        path.addLine(to: CGPoint(x: w * 0.75, y: h * 0.80))
        path.addLine(to: CGPoint(x: w * 0.75, y: h * 0.92))
        path.addLine(to: CGPoint(x: w * 0.25, y: h * 0.92))
        path.closeSubpath()
        // flame
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.40))
        path.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.62),
                          control: CGPoint(x: w * 0.62, y: h * 0.51))
        path.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.40),
                          control: CGPoint(x: w * 0.38, y: h * 0.51))
        return path
    }
}

// MARK: - Bonfire
struct BonfireShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        // logs
        path.move(to: CGPoint(x: w * 0.15, y: h * 0.85))
        path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.85))
        path.move(to: CGPoint(x: w * 0.2, y: h * 0.92))
        path.addLine(to: CGPoint(x: w * 0.8, y: h * 0.92))
        path.move(to: CGPoint(x: w * 0.25, y: h * 0.85))
        path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.92))
        path.move(to: CGPoint(x: w * 0.15, y: h * 0.92))
        path.addLine(to: CGPoint(x: w * 0.75, y: h * 0.85))
        // flame
        path.move(to: CGPoint(x: w * 0.5, y: h * 0.10))
        path.addQuadCurve(to: CGPoint(x: w * 0.30, y: h * 0.75),
                          control: CGPoint(x: w * 0.25, y: h * 0.45))
        path.addQuadCurve(to: CGPoint(x: w * 0.70, y: h * 0.75),
                          control: CGPoint(x: w * 0.50, y: h * 0.55))
        path.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.10),
                          control: CGPoint(x: w * 0.75, y: h * 0.45))
        return path
    }
}

// MARK: - Person silhouette
struct PersonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        // head
        path.addEllipse(in: CGRect(x: w * 0.35, y: h * 0.08, width: w * 0.30, height: h * 0.30))
        // body
        path.move(to: CGPoint(x: w * 0.25, y: h * 0.95))
        path.addLine(to: CGPoint(x: w * 0.30, y: h * 0.50))
        path.addQuadCurve(to: CGPoint(x: w * 0.70, y: h * 0.50),
                          control: CGPoint(x: w * 0.5, y: h * 0.40))
        path.addLine(to: CGPoint(x: w * 0.75, y: h * 0.95))
        return path
    }
}

// MARK: - Chevron right
struct ChevronRightShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.3, y: rect.minY + rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.7, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.3, y: rect.minY + rect.height * 0.85))
        return path
    }
}

// MARK: - Padlock
struct PadlockShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        // shackle
        path.move(to: CGPoint(x: w * 0.28, y: h * 0.45))
        path.addLine(to: CGPoint(x: w * 0.28, y: h * 0.30))
        path.addArc(center: CGPoint(x: w * 0.50, y: h * 0.30),
                    radius: w * 0.22, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: w * 0.72, y: h * 0.45))
        // body
        path.move(to: CGPoint(x: w * 0.18, y: h * 0.45))
        path.addLine(to: CGPoint(x: w * 0.82, y: h * 0.45))
        path.addLine(to: CGPoint(x: w * 0.82, y: h * 0.92))
        path.addLine(to: CGPoint(x: w * 0.18, y: h * 0.92))
        path.closeSubpath()
        // keyhole
        path.addEllipse(in: CGRect(x: w * 0.45, y: h * 0.60, width: w * 0.10, height: h * 0.10))
        return path
    }
}

// MARK: - Check
struct CheckShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: w * 0.15, y: h * 0.55))
        path.addLine(to: CGPoint(x: w * 0.40, y: h * 0.80))
        path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.25))
        return path
    }
}

// MARK: - Quill (3-stroke)
struct QuillShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        // main stroke
        path.move(to: CGPoint(x: w * 0.10, y: h * 0.90))
        path.addLine(to: CGPoint(x: w * 0.90, y: h * 0.10))
        // feather curve 1
        path.move(to: CGPoint(x: w * 0.60, y: h * 0.40))
        path.addQuadCurve(to: CGPoint(x: w * 0.95, y: h * 0.20),
                          control: CGPoint(x: w * 0.85, y: h * 0.05))
        // feather curve 2
        path.move(to: CGPoint(x: w * 0.45, y: h * 0.55))
        path.addQuadCurve(to: CGPoint(x: w * 0.85, y: h * 0.30),
                          control: CGPoint(x: w * 0.85, y: h * 0.20))
        return path
    }
}

// MARK: - Mug
struct MugShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        // body
        path.move(to: CGPoint(x: w * 0.18, y: h * 0.25))
        path.addLine(to: CGPoint(x: w * 0.70, y: h * 0.25))
        path.addLine(to: CGPoint(x: w * 0.68, y: h * 0.85))
        path.addLine(to: CGPoint(x: w * 0.20, y: h * 0.85))
        path.closeSubpath()
        // handle
        path.move(to: CGPoint(x: w * 0.70, y: h * 0.40))
        path.addQuadCurve(to: CGPoint(x: w * 0.70, y: h * 0.70),
                          control: CGPoint(x: w * 0.95, y: h * 0.55))
        // steam
        path.move(to: CGPoint(x: w * 0.30, y: h * 0.15))
        path.addQuadCurve(to: CGPoint(x: w * 0.40, y: h * 0.00),
                          control: CGPoint(x: w * 0.25, y: h * 0.08))
        path.move(to: CGPoint(x: w * 0.55, y: h * 0.15))
        path.addQuadCurve(to: CGPoint(x: w * 0.65, y: h * 0.00),
                          control: CGPoint(x: w * 0.50, y: h * 0.08))
        return path
    }
}

// MARK: - Icon wrapper helpers (stroke-style)
struct StrokeIcon<S: Shape>: View {
    let shape: S
    let size: CGFloat
    let color: Color
    let lineWidth: CGFloat

    init(_ shape: S, size: CGFloat, color: Color, lineWidth: CGFloat = 2) {
        self.shape = shape
        self.size = size
        self.color = color
        self.lineWidth = lineWidth
    }

    var body: some View {
        shape
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            .frame(width: size, height: size)
    }
}

struct FilledIcon<S: Shape>: View {
    let shape: S
    let size: CGFloat
    let color: Color

    init(_ shape: S, size: CGFloat, color: Color) {
        self.shape = shape
        self.size = size
        self.color = color
    }

    var body: some View {
        shape
            .fill(color)
            .frame(width: size, height: size)
    }
}
