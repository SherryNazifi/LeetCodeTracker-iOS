import Foundation

final class ProblemListViewModel: ObservableObject {

  // Handles persistence (load/save)
  private let store = ProblemStore()

  // Source of truth for all problems
  // Automatically saves whenever it changes
  @Published var problems: [Problem] = [] {
    didSet {
      saveProblems()
    }
  }

  // Set of unique days on which at least one problem was solved
  // Normalized to start-of-day to avoid time issues
  var solvedDays: Set<Date> {
    let calendar = Calendar.current
    return Set(
      problems
        .compactMap { $0.dateSolved }
        .map { calendar.startOfDay(for: $0) }
    )
  }

  // Current consecutive-day solving streak
  // Counts backward from today until a day is missing
  var currentStreak: Int {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())

    var streak = 0
    var currentDay = today

    while solvedDays.contains(currentDay) {
      streak += 1
      guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay) else {
        break
      }
      currentDay = previousDay
    }
    return streak
  }

  // Aggregated statistics for each pattern
  // Used for analytics, charts, and recommendations
  var patternStats: [PatternStats] {
    Pattern.allCases.map { pattern in

      // All problems tagged with this pattern
      let problemsForPattern = problems.filter {
        $0.patterns.contains(pattern)
      }

      // Number of solved problems for this pattern
      let solvedCount = problemsForPattern.filter {
        $0.isSolved
      }.count

      return PatternStats(
        pattern: pattern,
        total: problemsForPattern.count,
        solved: solvedCount
      )
    }
  }

  // Patterns with enough data and low solve rate
  // Used to prioritize review
  var weakPatterns: [PatternStats] {
    patternStats
      .filter { $0.total >= 3 && $0.solveRate < 0.6 }
      .sorted { $0.solveRate < $1.solveRate }
  }

  // Patterns with strong performance
  // Used to de-prioritize review
  var strongPatterns: [PatternStats] {
    patternStats
      .filter { $0.total >= 3 && $0.solveRate > 0.8 }
      .sorted { $0.solveRate < $1.solveRate }
  }

  // Set of weak pattern identifiers for fast lookup
  private var weakPatternsSet: Set<Pattern> {
    Set(weakPatterns.map { $0.pattern })
  }

  // Set of strong pattern identifiers for fast lookup
  private var strongPatternsSet: Set<Pattern> {
    Set(strongPatterns.map { $0.pattern })
  }

  // Computes a review priority score for a problem
  // Higher score = more important to review today
  func reviewScore(for problem: Problem) -> Double {
    var score: Double = 0

    // Pattern-based weighting
    if problem.patterns.contains(where: { weakPatternsSet.contains($0) }) {
      score += 3.0
    } else if problem.patterns.contains(where: { strongPatternsSet.contains($0) }) {
      score += 0.0
    } else {
      score += 1.0
    }

    // Difficulty-based weighting
    if problem.difficulty == .easy {
      score += 0.5
    } else if problem.difficulty == .medium {
      score += 1.0
    } else {
      score += 1.5
    }

    // Solved / recency weighting
    if !problem.isSolved {
      score += 2.0
    } else if let solvedDate = problem.dateSolved {
      let daysSinceSolved =
        Calendar.current.dateComponents([.day], from: solvedDate, to: Date()).day ?? 0

      if daysSinceSolved >= 14 {
        score += 1.5
      } else if daysSinceSolved >= 7 {
        score += 1.0
      }
    }

    return score
  }

  // Top problems to review today based on computed score
  var todaysRecommendations: [Problem] {
    problems
      .map { (problem: $0, score: reviewScore(for: $0)) }
      .sorted { $0.score > $1.score }
      .prefix(5)
      .map { $0.problem }
  }

  // Loads saved problems on initialization
  init() {
    loadProblems()
  }

  // Reads problems from persistent storage
  func loadProblems() {
    problems = store.load()
  }

  // Writes problems to persistent storage
  func saveProblems() {
    store.save(problems)
  }
}

