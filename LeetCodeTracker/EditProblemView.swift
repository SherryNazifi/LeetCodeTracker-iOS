import SwiftUI

struct EditProblemView: View {

  // Binding to the problem being edited
  // Changes here directly update the source problem
  @Binding var problem: Problem

  // Used to dismiss the sheet
  @Environment(\.dismiss) private var dismiss

  // Grid layout for pattern pills
  private let patternColumns = [
    GridItem(.adaptive(minimum: 120), spacing: 14)
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

          // Edit problem title
          Section("Title") {
            TextField("Problem title", text: $problem.title)
          }

          // Edit problem difficulty
          Section("Difficulty") {
            Picker("Difficulty", selection: $problem.difficulty) {
              ForEach(Difficulty.allCases, id: \.self) { level in
                Text(level.label).tag(level)
              }
            }
            .pickerStyle(.segmented)
          }

          // Notes input with placeholder behavior
          Section("Notes") {
            ZStack(alignment: .topLeading) {

              // Placeholder text shown only when notes are empty
              if problem.notes.isEmpty {
                Text("Write notes about your approach, edge cases, or mistakes…")
                  .foregroundColor(.secondary)
                  .padding(.horizontal, 12)
                  .padding(.vertical, 12)
              }

              // Multi-line text editor for notes
              TextEditor(text: $problem.notes)
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
                  isSelected: problem.patterns.contains(pattern)
                ) {

                  // Toggle pattern selection
                  if problem.patterns.contains(pattern) {
                    problem.patterns.removeAll { $0 == pattern }
                  } else {
                    problem.patterns.append(pattern)
                  }
                }
              }
            }
            .padding(12)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
          }
        }
        .scrollContentBackground(.hidden)
      }
      .navigationTitle("Edit Problem")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {

        // Save changes and close the sheet
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") {
            dismiss()
          }
          .foregroundColor(.appOrange)
        }
      }
    }
  }
}

#Preview {
  EditProblemView(
    problem: .constant(
      Problem(
        title: "Two Sum",
        difficulty: .easy,
        isSolved: false,
        notes: "",
        patterns: []
      )
    )
  )
}

