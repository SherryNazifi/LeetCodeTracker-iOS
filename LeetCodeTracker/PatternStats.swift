import Foundation

// Holds aggregated statistics for a single problem pattern
// Used for analytics, charts, and recommendation logic
struct PatternStats {

  // The pattern this stat represents
  let pattern: Pattern

  // Total number of problems tagged with this pattern
  let total: Int

  // Number of solved problems for this pattern
  let solved: Int

  // Solve rate expressed as a value between 0 and 1
  // Safely handles division by zero
  var solveRate: Double {
    total == 0 ? 0 : Double(solved) / Double(total)
  }
}

