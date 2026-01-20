import Foundation
import SwiftUI

// Represents common LeetCode problem patterns
// Used for tagging, filtering, and analytics
enum Pattern: String, CaseIterable, Codable, Identifiable {

  // Algorithmic / technique-based patterns
  case twoPointers = "Two Pointers"
  case slidingWindow = "Sliding Window"
  case binarySearch = "Binary Search"
  case greedy = "Greedy"
  case backtracking = "Backtracking"
  case bitManipulation = "Bit Manipulation"

  // Data structure–based patterns
  case array = "Array"
  case string = "String"
  case linkedList = "Linked List"
  case stack = "Stack"
  case heap = "Heap / Priority Queue"
  case tree = "Tree"
  case trie = "Trie"
  case graph = "Graph"

  // Traversal / search patterns
  case dfs = "DFS"
  case bfs = "BFS"

  // Dynamic programming patterns
  case dp1D = "DP (1D)"
  case dp2D = "DP (2D)"

  // Other common categories
  case intervals = "Intervals"
  case math = "Math / Geometry"

  // Conformance to Identifiable using the raw string value
  var id: String { rawValue }

  // Color associated with each pattern
  // Used for pills, charts, and visual grouping
  var color: Color {
      switch self {

      case .twoPointers:
          return .blue

      case .slidingWindow:
          return .teal

      case .binarySearch:
          return .indigo

      case .greedy:
          return .green

      case .backtracking:
          return .purple

      case .bitManipulation:
          return .pink

      case .array:
          return .cyan

      case .string:
          return .mint

      case .linkedList:
          return .brown

      case .stack:
          return .gray

      case .heap:
          return .yellow

      case .trie:
          return .teal.opacity(0.7)

      case .tree:
          return .green.opacity(0.8)

      case .graph:
          return .blue.opacity(0.7)

      case .dfs:
          return .purple.opacity(0.85)

      case .bfs:
          return .indigo.opacity(0.85)

      case .dp1D:
          return .orange

      case .dp2D:
          return .red

      case .intervals:
          return .yellow.opacity(0.85)

      case .math:
          return .pink.opacity(0.8)
      }
  }
}

