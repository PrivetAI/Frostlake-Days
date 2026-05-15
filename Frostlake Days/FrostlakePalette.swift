import SwiftUI

enum FrostlakePalette {
    // Warm parchment cream
    static let parchment = Color(red: 0xF4 / 255, green: 0xEC / 255, blue: 0xDA / 255)
    // Deep teal
    static let teal = Color(red: 0x1E / 255, green: 0x5A / 255, blue: 0x6C / 255)
    // Ember orange
    static let ember = Color(red: 0xD8 / 255, green: 0x66 / 255, blue: 0x38 / 255)
    // Frosted mint
    static let mint = Color(red: 0xB7 / 255, green: 0xD9 / 255, blue: 0xD2 / 255)
    // Ink charcoal
    static let ink = Color(red: 0x2E / 255, green: 0x2B / 255, blue: 0x2B / 255)
    // Fox-tail brown
    static let foxBrown = Color(red: 0x7B / 255, green: 0x4A / 255, blue: 0x2E / 255)
    // Sky pale
    static let skyPale = Color(red: 0xDC / 255, green: 0xEB / 255, blue: 0xF0 / 255)

    // Tier colors
    static func tierColor(_ tier: Int) -> Color {
        switch tier {
        case 0: return FrostlakePalette.foxBrown.opacity(0.55)
        case 1: return FrostlakePalette.teal.opacity(0.7)
        case 2: return FrostlakePalette.ember
        case 3: return FrostlakePalette.ember
        default: return FrostlakePalette.foxBrown
        }
    }
}

enum FrostlakeTypography {
    static func serifTitle(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }
    static func serifBody(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .serif)
    }
    static func monoDate(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .monospaced)
    }
}
