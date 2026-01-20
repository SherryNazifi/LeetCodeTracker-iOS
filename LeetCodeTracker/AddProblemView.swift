import SwiftUI

struct AddProblemView: View {

  // Controls whether the add-problem sheet is visible
  @Binding var isShowingAddProblem: Bool

  // Local form state
  @State private var title = ""
  @State private var notes = ""
  @State private var selectedDifficulty: Difficulty = .easy
  @State private var selectedPatterns: [Pattern] = []

  // Callback used to pass the new problem back to the parent view
  let onSave: (Problem) -> Void

  // Grid layout for pattern pills
  private let patternColumns = [
    GridItem(.adaptive(minimum: 120), spacing: 14)
  ]

  // Determines whether the Save button should be enabled
  private var canSave: Bool {
    !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  var body: some View {
    NavigationStack {
      ZStack {

        // Background gradient matching app theme
        LinearGradient(
          colors: [.appOrange.opacity(0.85), .black],
          startPoint: .topLeading,
          endPoint: .bottom
        )
        .ignoresSafeArea()

        // Main form content
        Form {

          // Input for problem title
          TextField("Problem Name", text: $title)

          // Difficulty selection
          Picker("Difficulty", selection: $selectedDifficulty) {
            Text("Easy").tag(Difficulty.easy)
            Text("Medium").tag(Difficulty.medium)
            Text("Hard").tag(Difficulty.hard)
          }

          // Notes input with placeholder behavior
          Section("Notes") {
            ZStack(alignment: .topLeading) {

              // Placeholder text shown only when notes are empty
              if notes.isEmpty {
                Text("Write notes about your approach, edge cases, or mistakes…")
                  .foregroundColor(.white.opacity(0.4))
                  .padding(.horizontal, 12)
                  .padding(.vertical, 12)
              }

              // Multi-line text editor
              TextEditor(text: $notes)
                .foregroundColor(.white)
                .padding(8)
                .frame(minHeight: 120)
                .background(
                  RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.08))
                )
            }
          }

          // Pattern selection grid
          Section("Patterns") {
            LazyVGrid(columns: patternColumns, alignment: .leading, spacing: 14) {
              ForEach(Pattern.allCases) { pattern in
                PatternPill(
                  pattern: pattern,
                  isSelected: selectedPatterns.contains(pattern)
                ) {

                  // Toggle pattern selection
                  if selectedPatterns.contains(pattern) {
                    selectedPatterns.removeAll { $0 == pattern }
                  } else {
                    selectedPatterns.append(pattern)
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

      // Navigation title
      .navigationTitle("Add Problem")
      .navigationBarTitleDisplayMode(.inline)

      // Close button in the navigation bar
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            isShowingAddProblem = false
          } label: {
            Image(systemName: "xmark")
              .foregroundColor(.white)
          }
        }
      }

      // Bottom-aligned Save button inset above the safe area
      .safeAreaInset(edge: .bottom) {
        Button {
          onSave(
            Problem(
              title: title,
              difficulty: selectedDifficulty,
              notes: notes,
              patterns: selectedPatterns
            )
          )
          isShowingAddProblem = false
        } label: {
          Text("Save")
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
              canSave
                ? Color.appOrange
                : Color.white.opacity(0.2)
            )
            .clipShape(Capsule())
            .padding(.horizontal)
        }
        .disabled(!canSave)
        .opacity(canSave ? 1 : 0.5)
        .padding(.vertical, 12)
      }
    }
  }
}

#Preview {
  AddProblemView(isShowingAddProblem: .constant(true)) { _ in }
}

