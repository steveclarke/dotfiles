# Codebase Patterns to Reference

Always examine existing code before making technical decisions:

## Backend Patterns

- **API responses**: Check existing response templates/serializers for multi-field entity examples
- **Response wrappers**: Check how entities are wrapped (data and metadata patterns)
- **Search patterns**: Review how search functionality is implemented
- **Context separation**: Look for existing patterns where different contexts need different responses

## Frontend Patterns

- **Type organization**: Review existing type files for entity and response type patterns
- **Data mutations**: Review existing patterns for create/update operations
- **Context-specific types**: Review existing features that have context-specific vs shared types
- **Response structure**: See how frontend types mirror backend responses

## Authorization Patterns

- **Permission organization**: Review how permissions are organized by context
- **Context-specific permissions**: Same permission name may exist in different contexts with different scopes
- **Policy structure**: Check existing authorization policy patterns
- **Public API**: Note if public API uses different authentication (API keys vs sessions)
