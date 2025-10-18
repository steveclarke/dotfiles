# Todoist Daily Review - Usage Examples

## Example 1: Standard Daily Review

**User Input:**
```
Do my daily Todoist review
```

**Expected Workflow:**

1. **Fetch tasks:**
   ```
   Running: todoist list --filter "today"
   Found 5 tasks for today
   ```

2. **Identify investigation items:**
   ```
   Investigation items identified:
   - [ID: 12345] GitHub - rails/rails (new authentication feature)
   - [ID: 12346] Article: "Understanding Rust Ownership"
   - [ID: 12347] Vite - next generation frontend tooling

   Skipping action items:
   - [ID: 12348] Register steveclarke.dev domain
   - [ID: 12349] Schedule dentist appointment
   ```

3. **Process each item:**

   **Item 1: Rails Authentication Feature**
   - Web search for Rails new authentication
   - Generate summary with features, use cases
   - Append to `/Users/steve/Documents/Main/Daily/2025-10-18.md`
   - Mark task 12345 complete

   **Item 2: Rust Ownership Article**
   - Web search for the article
   - Summarize key concepts
   - Append to daily note
   - Mark task 12346 complete

   **Item 3: Vite**
   - Research Vite features and ecosystem
   - Document benefits vs. webpack
   - Append to daily note
   - Mark task 12347 complete

4. **Final Report:**
   ```
   Todoist Daily Review Complete!

   Processed 3 items:
   - Rails Authentication Feature
   - Understanding Rust Ownership (Article)
   - Vite - Frontend Tooling

   All summaries added to: /Users/steve/Documents/Main/Daily/2025-10-18.md

   Tasks marked complete: 3/3 successful
   ```

## Example 2: Handling Edge Cases

**User Input:**
```
Review my Todoist investigation items
```

**Scenario: Mixed results with some failures**

1. **Fetch tasks:**
   ```
   Found 3 investigation items
   ```

2. **Process items:**

   **Item 1: htmx - Success**
   - ✅ Research completed
   - ✅ Summary generated
   - ✅ Appended to daily note
   - ✅ Task marked complete

   **Item 2: Obscure GitHub repo - Partial failure**
   - ⚠️ Web search returned limited results
   - ✅ Created basic summary with available info
   - ✅ Appended to daily note with note about limited info
   - ✅ Task marked complete (documented what we could find)

   **Item 3: Internal company tool - No results**
   - ❌ Web search found nothing (internal/private tool)
   - ✅ Created placeholder summary noting it's internal
   - ✅ Appended to daily note
   - ⚠️ Task NOT marked complete (needs manual review)

3. **Final Report:**
   ```
   Todoist Daily Review Complete!

   Processed 3 items:
   - htmx (fully documented)
   - github.com/user/obscure-repo (limited info available)
   - Internal tool XYZ (no public info - needs manual review)

   All summaries added to: /Users/steve/Documents/Main/Daily/2025-10-18.md

   Tasks marked complete: 2/3 successful
   Task 12350 not completed - requires manual investigation
   ```

## Example 3: No Investigation Items Found

**User Input:**
```
Do my daily review
```

**Scenario: All tasks are action items**

1. **Fetch tasks:**
   ```
   Found 4 tasks for today
   ```

2. **Filter:**
   ```
   No investigation items found.

   Today's tasks are all action items:
   - Buy groceries
   - Call plumber
   - Deploy staging environment
   - Review team PR
   ```

3. **Response:**
   ```
   No investigation items found in today's Todoist tasks.
   All tasks appear to be action items rather than research/learning items.

   Would you like me to:
   1. Process a different date?
   2. Review a specific task manually?
   3. Check tasks with a different filter?
   ```

## Example 4: User Selects Specific Items

**User Input:**
```
Review my Todoist items but only the GitHub repos
```

**Workflow with filtering:**

1. **Fetch tasks:**
   ```
   Found 6 tasks for today
   ```

2. **Filter for GitHub repos only:**
   ```
   GitHub repositories identified:
   - [ID: 12351] facebook/react (new hooks feature)
   - [ID: 12352] denoland/deno

   Skipping other investigation items:
   - Article: "CSS Grid Best Practices"
   - Phoenix LiveView tutorial
   ```

3. **Ask for confirmation:**
   ```
   Found 2 GitHub repositories to review. Process these?
   - facebook/react
   - denoland/deno
   ```

4. **After confirmation, process only those items**

## Example 5: First-Time Setup

**User Input:**
```
Do my Todoist review
```

**Scenario: Obsidian vault not configured**

1. **Fetch tasks:** ✅ Success

2. **Process first item:** ✅ Research complete

3. **Try to append to daily note:** ❌ Vault not found
   ```
   Attempted to find Obsidian vault:
   - Checked: obsidian-cli print-default → command not found
   - Checked: /Users/steve/Documents/Main → not found

   Could you provide the path to your Obsidian vault?
   (The folder containing the .obsidian directory)
   ```

4. **User provides:** `/Users/steve/Obsidian/Personal`

5. **Continue processing:**
   ```
   Using vault: /Users/steve/Obsidian/Personal
   Daily note path: /Users/steve/Obsidian/Personal/Daily/2025-10-18.md

   ✅ Summary appended successfully
   ✅ Task marked complete
   ```

## Example 6: Custom Date Range

**User Input:**
```
Review my Todoist items from yesterday
```

**Workflow:**

1. **Adjust filter:**
   ```bash
   todoist list --filter "yesterday"
   ```

2. **Process items as normal**

3. **Append to yesterday's daily note:**
   ```
   Daily note path: /Users/steve/Documents/Main/Daily/2025-10-17.md
   ```

4. **Report:**
   ```
   Processed 2 items from yesterday:
   - Svelte 5 Runes
   - Bun Runtime

   Summaries added to: /Users/steve/Documents/Main/Daily/2025-10-17.md
   ```

## Example Output - Daily Note

**Before processing:**
```markdown
# 2025-10-18

## Morning Notes
- Met with team about Q4 planning
- Reviewed architecture docs

## Tasks
- Deploy new feature to staging
```

**After processing 2 investigation items:**
```markdown
# 2025-10-18

## Morning Notes
- Met with team about Q4 planning
- Reviewed architecture docs

## Tasks
- Deploy new feature to staging

## Todoist Review

### htmx
**Link:** https://htmx.org/
**Additional Resources:** https://github.com/bigskysoftware/htmx

**What it is:** A lightweight JavaScript library that allows you to access modern browser features directly from HTML using attributes, eliminating the need for complex JavaScript frameworks.

**Key Features:**
- AJAX requests via HTML attributes (hx-get, hx-post, etc.)
- CSS transitions for smooth UI updates
- WebSocket and SSE support built-in
- Extends HTML with hypermedia capabilities
- Tiny size (~14kb min.gz)

**Why it's interesting:** Enables building dynamic, interactive web applications with minimal JavaScript. Perfect for server-side rendered apps that need progressive enhancement without adopting a full SPA framework.

**Use case:** Great for Rails, Django, Laravel apps that want modern UX without React/Vue complexity. Ideal for CRUD apps, dashboards, and form-heavy applications.

**Next steps:** Try integrating with a Rails project for dynamic form validation and real-time updates.

### Turbo (Hotwire)
**Link:** https://turbo.hotwired.dev/
**Additional Resources:** https://github.com/hotwired/turbo

**What it is:** Part of the Hotwire suite from Basecamp, Turbo accelerates navigation and form submissions by replacing only the changed parts of the page without full page reloads.

**Key Features:**
- Turbo Drive: Converts app into SPA-like experience
- Turbo Frames: Scope updates to specific page sections
- Turbo Streams: Real-time partial page updates via WebSockets
- Native mobile wrapper support
- Works seamlessly with traditional server-rendered HTML

**Why it's interesting:** Offers SPA-like speed and interactivity while keeping a traditional server-side architecture. Reduces JavaScript complexity and improves perceived performance.

**Use case:** Perfect for Rails, Phoenix, or any server-rendered framework wanting modern UX. Particularly good for real-time features like notifications, chat, live updates.

**Next steps:** Explore using with Rails 8 for building a real-time dashboard.
```

## Tips for Users

**Trigger Phrases:**
- "Do my daily Todoist review"
- "Review my Todoist investigation items"
- "Process my research tasks"
- "Check today's Todoist learning items"

**Customization Options:**
- Specify date: "Review yesterday's items"
- Filter by type: "Only review the GitHub repos"
- Manual selection: "Let me choose which items to review"

**Best Practices:**
- Run this daily to keep your research organized
- Review the generated summaries in your daily note
- Use consistent Todoist task naming for better filtering
- Tag investigation items in Todoist with labels if desired
