---
name: rails-patterns
description: Research how production Rails apps solve architectural problems using the Real World Rails repository. Use when the user wants to know how other apps handle something, find patterns, or compare approaches. Triggers on "rails patterns", "how do other apps", "real world rails", "research how apps do".
---

# Rails Pattern Research

## What This Is

The **Real World Rails** repository is a collection of 170+ production Rails
application source code. The `apps/` directory contains the full source of
each app — models, migrations, schema, controllers, views, concerns, gems.

Notable apps in the collection include Redmine, GitLab, Discourse, Mastodon,
Chatwoot, Forem, Spree, Solidus, Fat Free CRM, Loomio, Locomotive CMS, and
Camaleon CMS, among many others.

## Locating the Repository

Look for a directory called `real-world-rails` with an `apps/` subdirectory.
Check the current working directory first, then `~/src/real-world-rails`. If
not found, ask the user where it lives.

## What To Do

The user gives you a topic. Spin up parallel agents to search the apps for
how real codebases implement that pattern. Read actual code — models,
schemas, migrations, associations, validations, query patterns — not just
file names. Synthesize what you find into a clear analysis.

If the user's wording suggests they want help choosing a pattern for their
current project (words like "compare for us", "which fits best",
"adversarial", "debate", "evaluate for our project"), also spin up adversarial
agents that each argue for a different pattern in the context of the current
project's architecture and goals.
