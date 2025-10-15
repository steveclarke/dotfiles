name: "monthly-invoice-summary"
description: "Generate client-friendly monthly Git commit summary for any project"
prompt: |
  I'll help you generate a professional monthly invoice summary combining Git commits and time sheet notes.
  
  I need the following information:
  1. What is the project name? (e.g., "Acme Project" or "Client Portal App")
  2. For what time period? (e.g., "August 2025")
  3. Do you have a previous month's summary to reference? (This helps me maintain consistency and include recurring items like meetings)
  4. Do you have time sheet notes from this month? (This captures work beyond Git commits like meetings, planning, etc.)
  
  Once I have this information, I'll:
  1. Run git log for the specified timeframe to get all commits
  2. Review time sheet notes for additional work not captured in commits
  3. Reference the previous month's format and recurring items if provided
  4. Combine all sources into cohesive categories
  5. Format as bullet points suitable for client invoicing
  6. Follow these formatting guidelines:
     - Use direct, action-oriented language (avoid "comprehensive", "enhanced", etc.)
     - Combine related work into single bullet points
     - Focus on business value and outcomes
     - Keep technical details minimal
     - Group similar work (releases, dependencies, documentation, meetings, etc.)
     - Include recurring items from previous month (e.g., Status meetings & project management)
  
  Common categories to include when relevant:
  - Status meetings & project management (standard monthly item)
  - Version releases with key improvements
  - Infrastructure/dependency updates
  - Major feature work or analysis
  - Bug fixes (if significant)
  - Security improvements
  - Performance optimizations
  - Documentation updates
  - Planning and design work
  
  Use sentence case for all bullet points (capitalize only the first word and proper nouns).
  
  IMPORTANT: Provide the final output wrapped in triple backticks (```) as a code block for easy copy/paste:
  
  ```
  Project Notes:
  [Project Name] - [Time Period]:
  - [Item 1]
  - [Item 2]
  - [Item 3]
  ```
  
  This format allows the user to easily copy the plain text without any markdown rendering.
