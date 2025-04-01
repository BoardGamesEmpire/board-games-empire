# Permission Policy System

The Permission Policy system provides a flexible, rule-based approach to access control that complements the role-based system. While roles bundle predefined permissions, policies allow for more dynamic, condition-based permission decisions.

## Core Concepts

### PermissionPolicy

A `PermissionPolicy` defines a set of permissions that should be granted or denied when certain conditions are met.

Key attributes:

- **name**: Identifier for the policy
- **resourceType**: What kind of resource this policy applies to
- **effect**: Whether to Allow or Deny the permissions
- **conditions**: JSON object with conditional logic
- **permissions**: Array of specific permissions this policy governs

### Policy Assignments

Policies can be assigned to different entities through assignment models:

- `RolePolicyAssignment`: Attaches policies to roles
- `UserPolicyAssignment`: Attaches policies directly to users
- `GroupPolicyAssignment`: Attaches policies to permission groups
- `ResourcePolicyAssignment`: Attaches policies to specific resources

## How It Works

1. **Policy Definition**: Administrators define policies with specific conditions
2. **Policy Assignment**: Policies are assigned to roles, users, groups, or resources
3. **Permission Evaluation**: When a permission check occurs, the system:
   - Retrieves all applicable policies
   - Evaluates their conditions against the current context
   - Determines the final permission based on policy effects and priorities

## Example Use Cases

### Conditional Access

```typescript
// Policy: "Allow editing game data if user created the game"
{
  name: "CreatorCanEditGame",
  resourceType: ResourceType.Game,
  effect: PolicyEffect.Allow,
  conditions: {
    field: "createdById",
    operation: "equals",
    value: "{{currentUserId}}"
  },
  permissions: ["UpdateGame", "DeleteGame"]
}
```

### Time-Based Permissions

```typescript
// Policy: "Event organizers can edit events until 24 hours before start"
{
  name: "EventOrganizersPreEventEdit",
  resourceType: ResourceType.Event,
  effect: PolicyEffect.Allow,
  conditions: {
    userIsOrganizer: true,
    timeUntilEvent: { min: 24, unit: "hours" }
  },
  permissions: ["UpdateEvent"]
}
```

### Resource-Specific Rules

```typescript
// Policy: "Only adults can view this specific game"
// Applied to a specific resource (game) via ResourcePolicyAssignment
{
  name: "AdultsOnlyContent",
  resourceType: ResourceType.Game,
  effect: PolicyEffect.Allow,
  conditions: {
    userAge: { min: 18 }
  },
  permissions: ["ViewGame"]
}
```

## Integration with Role-Based Access Control

The policy system works alongside the role-based system:

1. **Complementary Approach**: Roles provide baseline permissions, while policies add conditional logic
2. **Precedence**: Explicitly denied permissions (via Deny policies) take precedence over allowed permissions
3. **Priority**: Policy assignments have priority levels to resolve conflicts

## Implementation Notes

When implementing permission checks, use this evaluation order:

1. Check explicit Deny policies (highest precedence)
2. Check explicit Allow policies
3. Check role-based permissions
4. Default to deny if no permissions are granted

The conditions field supports variables (e.g., `{{currentUserId}}`) that are replaced during evaluation with contextual values.

## Benefits Over Simple Role-Based Access Control

- **Contextual Decisions**: Permissions based on time, resource attributes, user properties
- **Reduced Role Proliferation**: Avoid creating specialized roles for every permission scenario
- **Centralized Rules**: Define access patterns once and reuse them
- **Dynamic Responses**: Permissions can change based on system state without changing role
  assignments
