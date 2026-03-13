# Home Heart Rain Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a pink heart button on the home header that triggers a full-screen heart rain animation and then returns to the normal page.

**Architecture:** `HomeView` owns a simple boolean for whether the animation is active. A dedicated `HeartRainOverlay` component renders the full-screen falling heart effect so the list, delete dialog, and card row code stay focused on their own responsibilities.

**Tech Stack:** SwiftUI, SF Symbols (`heart.fill`)

---

## Chunk 1: Header Entry

### Task 1: Add heart trigger in the header

**Files:**
- Modify: `/Users/feng/IOS_Projects/WPJ_IOS/WPJ_IOS/Views/Home/HomeView.swift`

- [ ] Step 1: Add a boolean state for the heart rain animation.
- [ ] Step 2: Replace the title-only header with a title + right-side heart button layout.
- [ ] Step 3: Clear temporary UI state before starting the animation.

## Chunk 2: Overlay Animation

### Task 2: Build a dedicated overlay component

**Files:**
- Create: `/Users/feng/IOS_Projects/WPJ_IOS/WPJ_IOS/Views/Home/HeartRainOverlay.swift`

- [ ] Step 1: Define a lightweight particle model for falling hearts.
- [ ] Step 2: Render many falling hearts using SwiftUI views and per-particle timing.
- [ ] Step 3: Fade the overlay out at the end and notify the parent view.

## Chunk 3: Regression Check

### Task 3: Verify existing home interactions still work

**Files:**
- Verify: `/Users/feng/IOS_Projects/WPJ_IOS/WPJ_IOS/Views/Home/HomeView.swift`
- Verify: `/Users/feng/IOS_Projects/WPJ_IOS/WPJ_IOS/Views/Home/StoredItemRow.swift`

- [ ] Step 1: Confirm the heart button appears in the header.
- [ ] Step 2: Confirm the animation blocks duplicate taps while active.
- [ ] Step 3: Confirm delete dialog, card expand, and swipe gestures still work after the animation ends.
