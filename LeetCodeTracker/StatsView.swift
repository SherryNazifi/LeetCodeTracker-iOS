import SwiftUI

struct StatsView: View {

  // ViewModel providing all problem data and derived analytics
  @ObservedObject var viewModel: ProblemListViewModel

  // Total number of problems
  private var totalCount: Int {
    viewModel.problems.count
  }

  // Number of solved problems
  private var solvedCount: Int {
    viewModel.problems.filter { $0.isSolved }.count
  }

  // Number of unsolved problems
  private var unsolvedCount: Int {
    totalCount - solvedCount
  }

  // Overall solve rate as a fraction (0–1)
  private var solveRate: Double {
    guard totalCount > 0 else { return 0 }
    return Double(solvedCount) / Double(totalCount)
  }

  // Count of problems by difficulty
  private var easyCount: Int {
    viewModel.problems.filter { $0.difficulty == .easy }.count
  }

  private var mediumCount: Int {
    viewModel.problems.filter { $0.difficulty == .medium }.count
  }

  private var hardCount: Int {
    viewModel.problems.filter { $0.difficulty == .hard }.count
  }

  // Used to normalize difficulty bar widths
  private var maxDifficultyCount: Int {
    max(easyCount, mediumCount, hardCount)
  }

  var body: some View {
    NavigationStack {
      ZStack {

        // Background gradient matching app theme
        LinearGradient(
          colors: [
            .appOrange.opacity(0.3),
            .appOrange.opacity(0.5),
            .appOrange.opacity(0.7),
            .black
          ],
          startPoint: .topTrailing,
          endPoint: .bottom
        )
        .ignoresSafeArea()

        // Empty state when there are no problems yet
        if viewModel.problems.isEmpty {
          ContentUnavailableView(
            "No data yet",
            systemImage: "chart.bar",
            description: Text("Solve some problems to see stats")
          )
        } else {

          // Main stats list
          List {

            // Basic counts
            Section {
              HStack {
                Text("Total problems")
                Spacer()
                Text("\(totalCount)")
              }

              HStack {
                Text("Solved")
                Spacer()
                Text("\(solvedCount)")
              }

              HStack {
                Text("Unsolved")
                Spacer()
                Text("\(unsolvedCount)")
              }
            }

            // High-level overview
            Section("Overview") {
              HStack {
                Text("Solve rate")
                Spacer()
                Text("\(Int(solveRate * 100))%")
              }
            }

            // Visual breakdown by difficulty
            Section("Difficulty Breakdown") {
              DifficultyBar(
                label: "Easy",
                count: easyCount,
                maxCount: maxDifficultyCount,
                color: .green
              )

              DifficultyBar(
                label: "Medium",
                count: mediumCount,
                maxCount: maxDifficultyCount,
                color: .yellow
              )

              DifficultyBar(
                label: "Hard",
                count: hardCount,
                maxCount: maxDifficultyCount,
                color: .red
              )
            }

            // Progress bar for overall solve rate
            Section("Progress") {
              VStack(alignment: .leading, spacing: 8) {
                HStack {
                  Text("Solve rate")
                  Spacer()
                  Text("\(Int(solveRate * 100))%")
                }

                ProgressView(value: solveRate)
                  .tint(.appOrange)
                  .padding(.vertical)
              }
            }

            // Current solving streak
            Section("Streaks") {
              Text(
                "\(viewModel.currentStreak) day\(viewModel.currentStreak == 1 ? "" : "s")"
              )
            }

            // Weak pattern analytics
            Section("Weak Patterns") {
              if viewModel.weakPatterns.isEmpty {
                Text("No weak patterns")
                  .foregroundStyle(.secondary)
              } else {
                ForEach(viewModel.weakPatterns, id: \.pattern.id) { stat in
                  VStack(alignment: .leading, spacing: 6) {

                    // Pattern name
                    Text(stat.pattern.rawValue)
                      .font(.headline)

                    // Progress bar showing solve rate
                    ProgressView(value: stat.solveRate)
                      .tint(stat.pattern.color)

                    // Solved count and percentage
                    Text("\(stat.solved)/\(stat.total) • \(Int(stat.solveRate * 100))%")
                      .font(.caption)
                      .foregroundStyle(.secondary)
                  }
                  .padding(.vertical, 4)
                }
              }
            }

            // Strong pattern analytics
            Section("Strong Patterns") {
              if viewModel.strongPatterns.isEmpty {
                Text("No strong patterns")
                  .foregroundStyle(.secondary)
              } else {
                ForEach(viewModel.strongPatterns, id: \.pattern.id) { stat in
                  VStack(alignment: .leading, spacing: 6) {

                    // Pattern name
                    Text(stat.pattern.rawValue)
                      .font(.headline)

                    // Progress bar showing solve rate
                    ProgressView(value: stat.solveRate)
                      .tint(stat.pattern.color)

                    // Solved count and percentage
                    Text("\(stat.solved)/\(stat.total) • \(Int(stat.solveRate * 100))%")
                      .font(.caption)
                      .foregroundStyle(.secondary)
                  }
                  .padding(.vertical, 4)
                }
              }
            }
          }
          .scrollContentBackground(.hidden)
        }
      }
      .navigationTitle("Stats")
    }
  }
}

// Reusable horizontal bar for difficulty counts
struct DifficultyBar: View {

  // Difficulty label (Easy / Medium / Hard)
  let label: String

  // Number of problems for this difficulty
  let count: Int

  // Maximum count among all difficulties
  let maxCount: Int

  // Bar color
  let color: Color

  var body: some View {
    HStack {

      // Difficulty label
      Text(label)
        .frame(width: 70, alignment: .leading)

      // Proportional bar using available width
      GeometryReader { geo in
        ZStack(alignment: .leading) {

          // Background track
          Capsule()
            .fill(Color.secondary.opacity(0.2))

          // Foreground bar scaled by difficulty count
          Capsule()
            .fill(color)
            .frame(
              width: geo.size.width * CGFloat(count) / CGFloat(maxCount)
            )
        }
      }
      .frame(height: 12)

      // Numeric count
      Text("\(count)")
        .frame(width: 30, alignment: .trailing)
    }
  }
}

#Preview {
  StatsView(viewModel: ProblemListViewModel())
}

