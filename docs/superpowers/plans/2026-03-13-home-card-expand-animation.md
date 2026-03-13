# Home Card Expand Animation Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add single-card expand/collapse animation on the home list while preserving swipe delete/edit behavior.

**Architecture:** `HomeView` owns the single expanded card id and passes focused view state into `StoredItemRow`. `StoredItemRow` handles only rendering and local no-image shake feedback, while expanded layout swaps the compact card content for a fixed-height detail presentation.

**Tech Stack:** SwiftUI, existing `StoredItem` model, local image loading through `ItemStore`

---

## Chunk 1: Expand State Wiring

### Task 1: Add Home-level expanded state

**Files:**
- Modify: `/Users/feng/IOS_Projects/WPJ_IOS/WPJ_IOS/Views/Home/HomeView.swift`

- [ ] Step 1: Add `expandedItemID` state to `HomeView`.
- [ ] Step 2: Pass `isExpanded` and `onTap` into each `StoredItemRow`.
- [ ] Step 3: Ensure tapping a new card collapses the old one and expands the new one.
- [ ] Step 4: Ensure tapping the expanded card collapses it.

## Chunk 2: Row Animation

### Task 2: Implement compact/expanded row layouts

**Files:**
- Modify: `/Users/feng/IOS_Projects/WPJ_IOS/WPJ_IOS/Views/Home/StoredItemRow.swift`

- [ ] Step 1: Add `isExpanded` and `onTap` parameters.
- [ ] Step 2: Keep the current compact layout unchanged for collapsed state.
- [ ] Step 3: Add a fixed-height expanded layout that shows only centered title and lower-centered image.
- [ ] Step 4: Hide swipe handling while expanded.
- [ ] Step 5: Add spring animation between collapsed and expanded heights.

### Task 3: Add no-image shake feedback

**Files:**
- Modify: `/Users/feng/IOS_Projects/WPJ_IOS/WPJ_IOS/Views/Home/StoredItemRow.swift`

- [ ] Step 1: Add local shake state.
- [ ] Step 2: Trigger shake on tap when the item has no image.
- [ ] Step 3: Keep shake feedback short and subtle.

## Chunk 3: Verification

### Task 4: Manual regression pass

**Files:**
- Verify: `/Users/feng/IOS_Projects/WPJ_IOS/WPJ_IOS/Views/Home/HomeView.swift`
- Verify: `/Users/feng/IOS_Projects/WPJ_IOS/WPJ_IOS/Views/Home/StoredItemRow.swift`

- [ ] Step 1: Confirm search results still filter correctly while cards are collapsed.
- [ ] Step 2: Confirm swipe delete/edit still works on collapsed cards.
- [ ] Step 3: Confirm expanded cards no longer respond to swipe.
- [ ] Step 4: Confirm delete dialog still appears and delete still removes the row.
- [ ] Step 5: Confirm editing navigation still opens the prefilled add page.
