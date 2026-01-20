import SwiftUI

struct TodayRecommendationsView: View {

  // Problems recommended for review today
  let problems: [Problem]

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {

      // Header row with title and icon
      HStack {
        Text("Today's Review")
          .font(.headline)

        Spacer()

        Image(systemName: "sparkles")
          .foregroundStyle(.secondary)
      }

      // Empty state when there is nothing to review
      if problems.isEmpty {
        Text("You’re all caught up 🎉")
          .font(.caption)
          .foregroundStyle(.secondary)
      } else {

        // Show up to the top 3 recommended problems
        ForEach(problems.prefix(3)) { problem in
          HStack(alignment: .center) {

            // Problem title and difficulty
            VStack(alignment: .leading, spacing: 2) {
              Text(problem.title)
                .font(.subheadline)
                .fontWeight(.medium)

              Text(problem.difficulty.label)
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            // Small color indicator for difficulty
            Circle()
              .fill(problem.difficulty.color)
              .frame(width: 8, height: 8)
          }
          .padding(.vertical, 6)
        }
      }
    }

    // Card-style container styling
    .padding()
    .background(.ultraThinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
}

#Preview {
  TodayRecommendationsView(
    problems: [
      Problem(
        title: "Two Sum",
        difficulty: .easy,
        isSolved: false,
        dateSolved: nil,
        notes: "",
        patterns: [.array, .twoPointers]
      ),
      Problem(
        title: "Longest Substring Without Repeating Characters",
        difficulty: .medium,
        isSolved: true,
        dateSolved: Date().addingTimeInterval(-86400 * 10),
        notes: "",
        patterns: [.slidingWindow, .string]
      ),
      Problem(
        title: "Coin Change",
        difficulty: .hard,
        isSolved: false,
        dateSolved: nil,
        notes: "",
        patterns: [.dp1D]
      )
    ]
  )
}

