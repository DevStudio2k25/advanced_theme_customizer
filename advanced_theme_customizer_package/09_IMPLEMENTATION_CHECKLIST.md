# Implementation Checklist

## Foundation
- [ ] Define scoped style model classes.
- [ ] Define registry metadata model.
- [ ] Finalize schema version constants.

## Resolver
- [ ] Implement merge order logic.
- [ ] Implement state-aware property lookup.
- [ ] Add fallback and warning hooks.

## Persistence and Migration
- [ ] Implement profile serializer and parser.
- [ ] Implement v1 to v2 migration.
- [ ] Add import modes: replace, merge, defaults.

## Draft Workflow
- [ ] Build draft session manager.
- [ ] Build apply transaction.
- [ ] Build discard transaction.
- [ ] Build bounded undo transaction.

## Panel UI
- [ ] Scope selector UI.
- [ ] Component and group browser UI.
- [ ] Property and state editor UI.
- [ ] Group apply UI.
- [ ] Copy and paste style UI.

## Preview
- [ ] Embedded preview panel widgets.
- [ ] In-page preview integration hook.
- [ ] Repaint optimization for live edits.

## Integration
- [ ] Settings mode launcher API.
- [ ] Per-page launcher API.
- [ ] Skin configuration API.
- [ ] Target lock API.

## Validation
- [ ] Unit tests for resolver.
- [ ] Unit tests for schema and migration.
- [ ] Widget tests for panel workflows.
- [ ] End-to-end tests for import and export.

## Release Readiness
- [ ] Final docs review.
- [ ] Compatibility notes for host developers.
- [ ] Versioned changelog for package release.
