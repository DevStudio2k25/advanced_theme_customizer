# Functional Requirements

## A. Scope and Targeting
FR-001: System must support global, page, component-group, and component-type targeting.
FR-002: System must resolve style using deterministic priority order.
FR-003: Every stylable target must have stable id and metadata.

## B. Style Dimensions
FR-010: Each target must support fill or background color.
FR-011: Each target must support border color.
FR-012: Each target must support text color.
FR-013: Each target must support icon color where applicable.
FR-014: Each target must support border radius.
FR-015: Each target must support border width.

## C. Interaction States
FR-020: System must support default state values.
FR-021: System must support hover state values.
FR-022: System must support focused state values.
FR-023: System must support active or pressed state values.
FR-024: System must support disabled state values.
FR-025: System must support selected state values.
FR-026: System must support error state values where applicable.

## D. Editing Workflow
FR-030: Editing must be draft-first by default.
FR-031: Draft changes must be visible in live preview immediately.
FR-032: Apply must commit draft to saved profile.
FR-033: Cancel or discard must restore last committed state.
FR-034: Undo must revert last apply action.

## E. Group and Batch Actions
FR-040: User must be able to select multiple components.
FR-041: User must apply same fill value to selected targets.
FR-042: User must apply same border value to selected targets.
FR-043: User must apply same text or icon value to selected targets.
FR-044: User must apply state-wise packs across selected targets.
FR-045: User must copy style from one target and paste to many targets.

## F. Import and Export
FR-050: Full profile JSON export must be supported.
FR-051: Full profile JSON import must be supported.
FR-052: Developer must be able to ship imported JSON as default profile.
FR-053: Versioned schema migration must be supported.

## G. Panel and Integration
FR-060: Package must provide built-in customization panel.
FR-061: Developer may skin panel visuals to match app theme.
FR-062: Developer must not modify locked panel functionality APIs.
FR-063: Panel must support settings mode integration.
FR-064: Panel must support per-page customize mode integration.

## H. Safety and Stability
FR-070: Invalid profile data must fail safely with fallback.
FR-071: Unknown component ids must not crash rendering.
FR-072: Scoped contrast warnings must be generated for risky combinations.
FR-073: Reset options must exist at component, group, page, and profile levels.
