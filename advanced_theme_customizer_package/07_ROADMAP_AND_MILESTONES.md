# Roadmap and Milestones

## Phase 1: Core Models and Schema
Deliverables:
1. Scoped style models.
2. Schema v2 parser and serializer.
3. v1 to v2 migration path.

## Phase 2: Resolver Engine
Deliverables:
1. Deterministic merge resolver.
2. State-aware property resolution.
3. Safe fallback and warning hooks.

## Phase 3: Registry and Metadata
Deliverables:
1. Component registry format.
2. Page and component id conventions.
3. Group tagging support for bulk operations.

## Phase 4: Draft and Commit Engine
Deliverables:
1. Draft session state manager.
2. Apply, discard, undo transactions.
3. Persistent commit storage integration.

## Phase 5: Panel v1
Deliverables:
1. Scope selector.
2. Component browser.
3. Property and state editor.
4. Group apply and copy or paste style actions.

## Phase 6: Preview Systems
Deliverables:
1. Embedded preview widgets.
2. In-page preview integration API.
3. Performance tuning for live updates.

## Phase 7: Integration Modes
Deliverables:
1. Settings-mode integration adapters.
2. Per-page launch adapters.
3. Skin configuration hooks.

## Phase 8: Hardening and Release
Deliverables:
1. Validation and migration tests.
2. Resolver correctness tests.
3. End-to-end import and export tests.
4. Documentation freeze and release checklist.

## Suggested Execution Strategy
1. Build package internals first.
2. Ship sample host app integration second.
3. Expand component registry coverage in waves.
