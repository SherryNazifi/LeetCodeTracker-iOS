import Foundation
import SwiftUI

// Centralized app color definitions
// This keeps the theme consistent across the entire app
extension Color {

    // Primary brand color used for accents, buttons, and highlights
    static let appOrange = Color(
        red: 244/255,
        green: 131/255,
        blue: 0/255
    )

    // Main background color for screens
    static let appBackground = Color.black

    // Semi-transparent card background used for list rows and containers
    static let appCard = Color.white.opacity(0.08)
}

