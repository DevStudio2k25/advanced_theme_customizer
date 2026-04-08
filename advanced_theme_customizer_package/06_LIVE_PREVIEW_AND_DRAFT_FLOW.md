# Live Preview and Draft Flow

## Preview Modes
1. Embedded preview mode inside panel.
2. In-page live preview mode via overlay or scoped edit mode.

## Draft Lifecycle
1. Start session:
   load committed profile into draft state.
2. Edit draft:
   every change updates preview immediately.
3. Apply draft:
   commit draft to persisted profile store.
4. Cancel or discard:
   drop draft and restore committed snapshot.
5. Undo apply:
   restore previous committed snapshot from bounded history.

## Real-Time Update Rules
1. Draft changes must never mutate committed state directly.
2. Preview must read from draft resolver while session is active.
3. Non-preview app rendering must remain stable until apply, unless page-level live preview mode is intentionally active.

## Undo Model
1. Keep bounded history stack, for example last 20 applies.
2. Undo operation restores exact previous committed snapshot.
3. Redo optional for later version.

## Performance Rules
1. Debounce rapid slider or picker events if needed.
2. Isolate heavy preview widgets with repaint boundaries.
3. Avoid full app rebuild for each draft event.

## Safety Rules
1. Invalid draft entry should not crash preview.
2. Failed apply must keep last committed state unchanged.
3. Draft session corruption must auto-reset to last committed snapshot.
