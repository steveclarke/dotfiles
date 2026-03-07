---
name: bruno-endpoint-creation
description: Create Bruno REST API endpoint configurations with proper authentication, environment setup, and documentation. Use when setting up API testing with Bruno, creating new endpoints, or configuring collection-level authentication. Triggers on "create Bruno endpoint", "Bruno API testing", "set up Bruno collection".
---

# Bruno Endpoint Creation

Bruno-specific patterns for creating `.bru` endpoint files. Assumes familiarity with REST conventions.

## Environment Configuration

**Development (Local.bru):**
```
vars {
  baseUrl: http://localhost:3001
  linkId:
  apiKey: dev_api_key_change_in_production
}
```

**Production/Staging — use `vars:secret` for sensitive data:**
```
vars {
  baseUrl: https://api.yourdomain.com
  linkId:
}
vars:secret [
  apiKey
]
```

## Collection-Level Authentication

Set auth once in `collection.bru`, then inherit in all endpoints:

```
auth {
  mode: bearer
}

auth:bearer {
  token: {{apiKey}}
}
```

Individual endpoints inherit with `auth: inherit`:
```
post {
  url: {{baseUrl}}/api/v1/resources
  body: json
  auth: inherit
}
```

Override per-endpoint only when auth differs from the collection.

## Request Structure

```
meta {
  name: "Create Resource"
  type: http
  seq: 1
}

post {
  url: {{baseUrl}}/api/v1/resources
  body: json
  auth: inherit
}

body:json {
  {
    "resource": {
      "field1": "value1",
      "field2": "value2"
    }
  }
}

params:path {
  id: {{resourceId}}
}

params:query {
  page: 1
  limit: 20
  sort: created_at
  order: desc
}
```

## Scripting API

**Post-response — extract data for subsequent requests:**
```javascript
script:post-response {
  if (res.status === 201 && res.body && res.body.id) {
    bru.setVar("resourceId", res.body.id);
  }
}
```

**Pre-request — generate dynamic data:**
```javascript
script:pre-request {
  const timestamp = Date.now();
  bru.setVar("uniqueEmail", `test-${timestamp}@example.com`);
}
```

**Key difference:**
- `bru.setVar()` — runtime variables (temporary, current collection run only)
- `bru.setEnvVar()` — environment variables (persists, visible in Environment tab)

Use `bru.setVar()` for ephemeral values like extracted IDs from test runs.

## Documentation Block

```
docs {
  Create a new resource in the system.

  **Required Fields:**
  - field1: Description
  - field2: Description

  **Optional Fields:**
  - optional_field: Description
}
```

## Collection Folder Structure

```
Bruno Collection/
├── Environments/
│   ├── Local.bru
│   ├── Staging.bru
│   └── Production.bru
├── Authentication/
│   ├── Login.bru
│   └── Refresh Token.bru
├── Resources/
│   ├── List Resources.bru
│   ├── Get Resource.bru
│   ├── Create Resource.bru
│   ├── Update Resource.bru
│   └── Delete Resource.bru
└── Health/
    └── Health Check.bru
```
