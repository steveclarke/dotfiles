# Multi-Context Architecture Patterns

When features span multiple application contexts (internal, external, public), follow these patterns:

## Complete Separation Principle

- **Handlers/Controllers**: Separate request handlers for each context
- **Response Templates**: Separate response structures for each context, even if currently identical
- **Authorization**: Separate authorization policies for each context; Public API may use different auth
- **Permissions**: Define permissions for each context with appropriate scopes
- **Types**: Context-specific types when data structures differ
- **Routes**: Different route namespaces or prefixes for each context

## Why Complete Separation

- **Security**: Prevents accidental data leakage between contexts
- **Flexibility**: Each context can evolve independently
- **Clarity**: Clear boundaries make intent explicit
- **Maintenance**: Changes to one context don't affect others

## Common Context Patterns

- **Internal/Admin context**: Full CRUD, includes management and audit fields
- **External/User context**: Limited operations, excludes internal fields
- **Public API**: Often most restricted, may use different authentication (API keys vs sessions)
