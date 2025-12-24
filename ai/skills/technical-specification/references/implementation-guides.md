# Implementation Guides Reference

If your project has implementation guides, reference them instead of including implementation code in specs. Specs should mention WHAT needs to be implemented and reference the appropriate guide for HOW to implement it.

## Common Guide Topics

- Search functionality patterns
- File upload and attachment patterns
- Audit trail / change tracking
- Multi-tenancy approaches
- Role-based authorization
- State machine patterns
- Testing patterns and conventions
- Authentication strategies
- Database migration best practices

## How to Reference Guides in Specs

✅ **Good practices:**
- "See implementation guide for search configuration details"
- "Follow established patterns for file attachment handling"
- "Reference authorization guide for permission structure"

❌ **Avoid:**
- Don't include implementation code in specs
- Don't duplicate guide content in specifications
