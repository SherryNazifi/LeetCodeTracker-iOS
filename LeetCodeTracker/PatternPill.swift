import SwiftUI

struct PatternPill: View {

  // The pattern this pill represents
  let pattern: Pattern

  // Whether this pill is currently selected
  let isSelected: Bool

  // Action to run when the pill is tapped
  let onTap: () -> Void
  
  var body: some View {
    Text(pattern.rawValue)

          // Small, compact label style
          .font(.caption.weight(.medium))

          // Prevents text from wrapping to a new line
          .lineLimit(1)

          // Ensures the pill sizes itself based on text width
          .fixedSize(horizontal: true, vertical: false)

          // Internal spacing for pill shape
          .padding(.horizontal, 14)
          .padding(.vertical, 8)

          // Background color changes based on selection state
          .background(
            isSelected
              ? pattern.color.opacity(0.85)
              : pattern.color.opacity(0.15)
          )

          // Text color adapts to selection
          .foregroundColor(isSelected ? .white : .primary)

          // Rounded pill shape
          .clipShape(Capsule())

          // Optional outline shown only when selected
          .overlay(
            Capsule()
              .stroke(
                isSelected ? Color.blue : Color.clear,
                lineWidth: 1
              )
          )

          // Tap interaction passed in from parent
          .onTapGesture(perform: onTap)

          // Smooth animation when selection changes
          .animation(.easeInOut(duration: 0.15), value: isSelected)
  }
}

