# Common Spec Pitfalls to Avoid

## Backend/API Section Pitfalls

❌ **Showing implementation code** - Show response structure, not how to build it  
❌ **Mixing layers** - Keep API sections pure backend, frontend types separate  
❌ **Over-engineering search** - Only add complex search when actually needed  
❌ **Unnecessary fields** - Ask whether audit/timestamp fields belong in API responses  
❌ **Spelling out standard patterns** - Reference standard patterns without repeating details  
❌ **Wrong location for parameters** - Document permitted attributes in authorization layer  
❌ **Reusing structures across contexts** - Always create separate structures for security  
❌ **Missing context authorization** - Define permissions for all contexts  
❌ **Generic "everything is sortable"** - List specific sortable columns  
❌ **Inconsistent authentication** - Document different auth approaches per context  

## Frontend/Type Section Pitfalls

❌ **Shared types for context-specific data** - Different contexts often need different type structures  
❌ **Centralizing request types** - Keep them colocated with usage  
❌ **Repetitive type definitions** - Don't duplicate types in API and Frontend sections  
❌ **Missing imports** - Type definitions need proper import statements  
❌ **Unused imports** - Only import types that are actually used  
❌ **Missing File Summary sections** - Start each context with quick reference cheat sheet  

## General Spec Pitfalls

❌ **Too much implementation code** - Specs define contracts, plans define implementation  
❌ **Repetitive examples** - Show pattern once, reference it elsewhere  
❌ **Missing architecture notes** - Explain WHY things are separate (security, isolation)  
❌ **Repeating permissions** - Reference Permission Definitions section, don't duplicate
