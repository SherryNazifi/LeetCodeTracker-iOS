import Foundation

final class ProblemStore {

  // Key used to store problems in UserDefaults
  private let key = "problems"

  // Saves the array of problems to persistent storage
  func save(_ problems: [Problem]) {
    // Encode problems as JSON data
    if let data = try? JSONEncoder().encode(problems) {
      // Persist encoded data in UserDefaults
      UserDefaults.standard.set(data, forKey: key)
    }
  }

  // Loads the array of problems from persistent storage
  func load() -> [Problem] {
    // Retrieve stored data
    if let data = UserDefaults.standard.data(forKey: key),

       // Decode JSON data back into Problem objects
       let decoded = try? JSONDecoder().decode([Problem].self, from: data) {
      return decoded
    }

    // Return empty array if no data exists or decoding fails
    return []
  }
}

