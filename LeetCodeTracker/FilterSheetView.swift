import SwiftUI

struct FilterSheetView: View {

  // Binding to the selected solved/unsolved filter
  @Binding var selectedFilter: ProblemFilter

  // Binding to the selected difficulty (optional = no filter)
  @Binding var selectedDifficulty: Difficulty?

  // Binding to the selected pattern (optional = no filter)
  @Binding var selectedPatterns: Pattern?

  // Used to dismiss the sheet
  @Environment(\.dismiss) private var dismiss

  // Grid layout for pattern pills
  private let patternColumns = [
    GridItem(.adaptive(minimum: 120), spacing: 12)
  ]

  var body: some View {
    NavigationStack {
      ZStack {

        // Background gradient matching the app theme
        LinearGradient(
          colors: [.appOrange.opacity(0.85), .black],
          startPoint: .topLeading,
          endPoint: .bottom
        )
        .ignoresSafeArea()

        Form {

          // Status filter (All / Solved / Unsolved)
          Section("Status") {
            Picker("Status", selection: $selectedFilter) {
              ForEach(ProblemFilter.allCases, id: \.self) { filter in
                Text(filter.rawValue).tag(filter)
              }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
          }

          // Difficulty filter using tappable pills
          Section("Difficulty") {
            HStack(spacing: 8) {
              difficultyPill(label: "Easy", value: .easy)
              difficultyPill(label: "Medium", value: .medium)
              difficultyPill(label: "Hard", value: .hard)
            }
            .padding(.top, 4)
          }

          // Pattern filter using a grid of selectable pills
          Section("Patterns") {
            LazyVGrid(columns: patternColumns, alignment: .leading, spacing: 14) {
              ForEach(Pattern.allCases) { pattern in
                PatternPill(
                  pattern: pattern,
                  isSelected: selectedPatterns == pattern
                ) {
                  // Toggle selection when tapped
                  if selectedPatterns == pattern {
                    selectedPatterns = nil
                  } else {
                    selectedPatterns = pattern
                  }
                }
              }
            }
            .padding(12)
            .background(
              RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.08))
            )
          }
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
      }
      .navigationTitle("Filters")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {

        // Clears all active filters
        ToolbarItem(placement: .topBarLeading) {
          Button("Clear") {
            selectedFilter = .all
            selectedDifficulty = nil
            selectedPatterns = nil
          }
          .foregroundColor(.white)
        }

        // Applies filters and closes the sheet
        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") {
            dismiss()
          }
          .foregroundColor(.white)
        }
      }
    }
  }

  // Builds a single difficulty pill (Easy / Medium / Hard)
  @ViewBuilder
  private func difficultyPill(label: String, value: Difficulty) -> some View {

    // Determines whether this pill is selected
    let isSelected = selectedDifficulty == value

    Text(label)
      .font(.caption.weight(.semibold))
      .padding(.horizontal, 14)
      .padding(.vertical, 6)
      .background(
        isSelected
          ? value.color
          : Color.white.opacity(0.15)
      )
      .foregroundColor(.white)
      .clipShape(Capsule())
      .onTapGesture {
        // Toggle difficulty selection
        selectedDifficulty = isSelected ? nil : value
      }
  }
}

