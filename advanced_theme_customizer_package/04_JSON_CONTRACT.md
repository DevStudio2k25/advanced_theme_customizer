# JSON Contract

## Schema Goals
1. Human readable for debugging.
2. Strict enough for validation.
3. Versioned for migrations.
4. Compatible with export and import cycles.

## Top-Level Shape
Example structure:
{
  "schemaVersion": 2,
  "profile": {
    "id": "custom_001",
    "name": "My Personalized UI",
    "updatedAt": "2026-04-08T12:00:00Z"
  },
  "base": {
    "presetId": "classic"
  },
  "rules": [
    {
      "scope": "page",
      "target": "login",
      "priority": 200,
      "styles": {
        "login.button.primary": {
          "default": {
            "fill": "#FF1A73E8",
            "border": "#FF0F4AA1",
            "text": "#FFFFFFFF",
            "radius": 14,
            "borderWidth": 1
          },
          "disabled": {
            "fill": "#661A73E8",
            "text": "#99FFFFFF"
          }
        }
      }
    }
  ]
}

## Field Definitions
1. schemaVersion: integer, required.
2. profile.id: string, required.
3. profile.name: string, required.
4. base.presetId: string, optional but recommended.
5. rules: array of scoped rule blocks.

## Rule Block Contract
1. scope: one of global, page, group, componentType.
2. target: scope-specific id string.
3. priority: integer, higher wins.
4. styles: map from component key to state map.

## State Map Contract
Allowed states:
1. default
2. hover
3. focused
4. active
5. disabled
6. selected
7. error

## Property Contract
Allowed properties:
1. fill
2. border
3. text
4. icon
5. radius
6. borderWidth

## Validation Rules
1. Color values must be ARGB or RGBA accepted format.
2. Radius and borderWidth must be non-negative numbers.
3. Unknown fields are ignored but logged.
4. Unknown scopes or targets are ignored safely.

## Import Modes
1. replace: replace complete profile.
2. merge: merge incoming rules into active profile.
3. defaults: treat JSON as app default baseline.

## Migration Notes
1. v1 token-only profile migrates to v2 global rules.
2. Migration must preserve all valid values.
3. On migration failure, keep old profile and fallback safely.
