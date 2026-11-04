---
name: bruno-endpoint-creation
description: "Adds or edits Bruno `.bru` request files in a project's Bruno collection following the house conventions for folders, auth and environments. Use when creating or changing a Bruno endpoint, folder or environment."
---

# Bruno endpoints

Read the project's own collection first (Outport: `~/src/outport-app/bruno/`, Unio: `backend/bruno/`) and copy a neighbouring request. This page holds only what differs from Bruno's defaults.

- **Layout.** The collection lives in the repo at `bruno/`. One folder per API surface (`portal/`, `public/`, `crm/`), each with a `folder.bru` for its name, `seq` and shared auth. A request file is named for what it does ("Fetch Organization").
- **Auth.** `collection.bru` sets `auth { mode: none }`. A surface that needs a token sets it once in its `folder.bru` (`mode: bearer`, `token: {{crmToken}}`), and its requests use `auth: inherit`. Requests on public surfaces say `auth: none`.
- **Environments.** `environments/dev.bru` and `staging.bru` only. Every URL, token and key is `{{process.env.BRUNO_*}}`, so the committed file holds no secrets; the values come from the developer's environment. Never type a real credential into an environment file.
- **Checks.** Each request has an `assert` or `tests` block that proves the status and the shape of the body, so a collection run is a smoke test.
- **Variables.** `bru.setVar()` is temporary and lasts one collection run, the right place for an id extracted from a response. `bru.setEnvVar()` persists in the environment, so it is for values that must outlive the run.
