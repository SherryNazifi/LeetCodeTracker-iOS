# LeetCode Tracker (iOS)

A SwiftUI-based iOS application designed to help structure algorithm practice by tracking solved problems, analyzing performance by pattern, and generating data-driven review recommendations.

---

## Overview

LeetCode Tracker enables users to log algorithm problems, tag them by core patterns, and monitor progress over time.  
The app focuses on identifying weak areas and prioritizing review based on difficulty, recency, and historical performance rather than random repetition.

---

## Screenshots

<p align="center">
  <img src="images/main.png" width="250" />
  <img src="images/add.png" width="250" />
  <img src="images/edit.png" width="250" />
  <img src="images/filter.png" width="250" />
  <img src="images/stats.png" width="250" />
  
</p>

## Features

- Problem tracking with difficulty, solve status, and notes
- Algorithmic pattern tagging (e.g., Two Pointers, Dynamic Programming, Graphs)
- Solve-rate analytics to identify weak and strong patterns
- Daily review recommendations generated from a weighted scoring system
- Solve streak tracking and progress monitoring
- Statistics dashboard with difficulty and performance breakdowns

---

## Technical Stack

- **Language:** Swift  
- **UI Framework:** SwiftUI  
- **Architecture:** MVVM (Model–View–ViewModel)  
- **State Management:** ObservableObject, @Published  
- **Persistence:** UserDefaults  
- **Platform:** iOS 17+

---

## Architecture

The application follows the MVVM architecture pattern:

- **Models** define problems, patterns, and statistical data
- **ViewModels** encapsulate business logic, persistence, and analytics
- **Views** reactively render UI based on published state

This separation ensures maintainability, scalability, and clear ownership of responsibilities.

---

## Data & Analytics

The app derives higher-level insights from user data, including:
- Solve rates per algorithmic pattern
- Identification of weak and strong topic areas
- A weighted review score that accounts for difficulty, recency, and problem status

These metrics are used to generate focused daily review recommendations.

---

## Motivation

This project was built to improve the efficiency and structure of algorithm practice by combining clean iOS architecture with meaningful performance analytics. The goal was to move beyond simple problem tracking and introduce data-driven review prioritization.

---

## Future Enhancements

- Cloud synchronization and authentication
- AI-assisted review planning and explanations
- Exportable analytics for external analysis
- App Store deployment

---

## Author

**Shahrzad Nazifi**
