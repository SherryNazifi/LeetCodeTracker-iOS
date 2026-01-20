import SwiftUI

// Shared store instance (used for persistence elsewhere)
private let store = ProblemStore()

// Difficulty levels for LeetCode problems
enum Difficulty: String, CaseIterable, Codable {
  case easy
  case medium
  case hard
  
  // Display-friendly label
  var label: String {
    switch self {
    case .easy : return "Easy"
    case .medium : return "Medium"
    case .hard : return "Hard"
    }
  }
  
  // Color associated with each difficulty
  var color: Color {
    switch self {
    case .easy : return .green
    case .medium : return .yellow
    case .hard : return .red
    }
  }
}

// Filter options for solved state
enum ProblemFilter: String, CaseIterable {
  case all = "All"
  case solved = "Solved"
  case unsolved = "Unsolved"
}

// Model representing a single problem
struct Problem: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var difficulty: Difficulty
    var isSolved: Bool = false
    var dateSolved: Date?
    var notes: String = ""
    var patterns: [Pattern] = []
}

struct ProblemListView: View {

    // ViewModel holds the source of truth
    @StateObject private var viewModel = ProblemListViewModel()

    // UI state
    @State private var isShowingAddProblem = false
    @State private var selectedProblemIndex: Problem?
    @State private var selectedFilter: ProblemFilter = .all
    @State private var searchText: String = ""
    @State private var selectedDifficulty: Difficulty? = nil
    @State private var selectedPattern: Pattern? = nil
    @State private var isShowingFilterSheet: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {

              // Background gradient
              LinearGradient(
                  colors: [.appOrange.opacity(0.7), .black],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
              )
              .ignoresSafeArea()

              // Empty state when no problems exist
              if viewModel.problems.isEmpty {
                ContentUnavailableView(label: {
                  Label("No problems yet", systemImage: "folder.badge.plus")
                    .foregroundStyle(.white)
                }, description: {
                  Text("Add problems to get started!")
                    .foregroundStyle(.secondary)
                })
              } else {
                // Main list when problems exist
                problemList
              }
            }
            .navigationTitle("LeetCode Tracker")

            // Search bar filtering by title
            .searchable(text: $searchText, prompt: "Search Problems")

            // Top navigation buttons
            .toolbar {

              // Add new problem
              ToolbarItem(placement: .topBarTrailing) {
                Button {
                  isShowingAddProblem = true
                } label: {
                  Image(systemName: "plus")
                    .foregroundColor(.black)
                    .imageScale(.large)
                    .frame(width: 44, height: 44)
                }
              }

              // Open filter sheet
              ToolbarItem(placement: .topBarTrailing){
                Button {
                  isShowingFilterSheet = true
                } label: {
                  Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundColor(.white)
                    .imageScale(.large)
                    .frame(width: 44, height: 44)
                }
              }

              // Navigate to stats view
              ToolbarItem(placement: .topBarLeading) {
                NavigationLink {
                  StatsView(viewModel: viewModel)
                } label: {
                  Image(systemName: "chart.bar.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                    .frame(width: 44, height: 44)
                }
              }
            }

            // Sheet for adding a new problem
            .sheet(isPresented: $isShowingAddProblem) {
                AddProblemView(
                    isShowingAddProblem: $isShowingAddProblem,
                    onSave: { newProblem in
                      viewModel.problems.append(newProblem)
                    }
                )
            }

            // Sheet for editing an existing problem
            .sheet(item: $selectedProblemIndex) { problem in
              if let index = viewModel.problems.firstIndex(where: { $0.id == problem.id }) {
                EditProblemView(problem: $viewModel.problems[index])
              }
            }

            // Sheet for filtering options
            .sheet(isPresented: $isShowingFilterSheet){
              FilterSheetView(
                selectedFilter: $selectedFilter,
                selectedDifficulty: $selectedDifficulty,
                selectedPatterns: $selectedPattern
              )
            }
        }
    }

  // Applies all filters and sorting to the problems array
  private var filteredAndSortedProblems: [Problem] {
    let filtered: [Problem]

    // Filter by solved state
    switch selectedFilter {
    case .all:
      filtered = viewModel.problems
    case .solved:
      filtered = viewModel.problems.filter { $0.isSolved }
    case .unsolved:
      filtered = viewModel.problems.filter { !$0.isSolved }
    }

    // Filter by search text
    let searched = searchText.isEmpty ? filtered : filtered.filter {
      $0.title.localizedCaseInsensitiveContains(searchText)
    }

    // Filter by difficulty
    let difficultyFiltered = selectedDifficulty == nil ? searched : searched.filter {
      $0.difficulty == selectedDifficulty
    }

    // Filter by pattern
    let patternFiltered = selectedPattern == nil ? difficultyFiltered : difficultyFiltered.filter { problem in
      problem.patterns.contains(selectedPattern!)
    }

    // Sort unsolved first, then most recently solved, then alphabetically
    return patternFiltered.sorted { a, b in
      if a.isSolved != b.isSolved {
        return !a.isSolved
      }

      if let dateA = a.dateSolved, let dateB = b.dateSolved {
        return dateA > dateB
      }

      return a.title < b.title
    }
  }

  // Maps filtered problems back to their real indices in the source array
  private var filteredSortedIndices: [Int] {
    filteredAndSortedProblems.compactMap { problem in
      viewModel.problems.firstIndex(where: { $0.id == problem.id })
    }
  }

  // List UI
  private var problemList: some View {
      List {

        // Daily recommendations section
        Section {
          TodayRecommendationsView(problems: viewModel.todaysRecommendations)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }

        // Render each problem row
        ForEach(filteredSortedIndices, id: \.self) { index in

          let problemBinding = $viewModel.problems[index]

          HStack(alignment: .center, spacing: 12) {

              // Toggle solved state
              Toggle("", isOn: problemBinding.isSolved)
                  .labelsHidden()
                  .tint(.appOrange)
                  .onChange(of: problemBinding.isSolved.wrappedValue) { oldValue, newValue in
                      problemBinding.dateSolved.wrappedValue = newValue ? Date() : nil
                  }

              // Title and solved status
              VStack(alignment: .leading, spacing: 4) {

                  Text(problemBinding.title.wrappedValue)
                      .font(.body)
                      .fontWeight(.medium)

                  if let date = problemBinding.dateSolved.wrappedValue {
                      Text("Solved on \(date.formatted(date: .abbreviated, time: .omitted))")
                          .font(.caption)
                          .foregroundStyle(.secondary)
                  } else {
                      Text("Not solved yet")
                          .font(.caption)
                          .foregroundStyle(.secondary)
                  }
              }

              Spacer()

              // Difficulty pill
              Text(problemBinding.difficulty.wrappedValue.label)
                  .font(.caption.weight(.semibold))
                  .foregroundColor(.white)
                  .padding(.horizontal, 10)
                  .padding(.vertical, 4)
                  .background(problemBinding.difficulty.wrappedValue.color)
                  .clipShape(Capsule())
          }
          .padding(.vertical, 8)
          .background(
            RoundedRectangle(cornerRadius: 14)
              .fill(Color.white.opacity(0.08))
          )
          .contentShape(Rectangle())

          // Open edit view on tap
          .onTapGesture {
            selectedProblemIndex = viewModel.problems[index]
          }
        }

        // Delete with correct index mapping
        .onDelete { (IndexSet) in
          for row in IndexSet {
            let realIndex = filteredSortedIndices[row]
            viewModel.problems.remove(at: realIndex)
          }
        }
      }
      .scrollContentBackground(.hidden)
  }
}

#Preview {
    ProblemListView()
}

