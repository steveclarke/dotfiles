# SyncBooks Development Reference

Development patterns and conventions for the syncbooks skill. This skill is a WIP that will eventually be extracted to a proper CLI in `~/src/syncbooks`.

## Architecture Overview

```
scripts/
├── syncbooks                    # Main CLI entry point (Thor)
└── lib/
    ├── syncbooks.rb             # Module loader
    ├── config.rb                # Configuration management
    ├── credentials.rb           # OAuth token storage
    ├── oauth_server.rb          # WEBrick callback server
    ├── ui.rb                    # Gum-based terminal UI helpers
    ├── freeagent_client.rb      # FreeAgent API client
    ├── google_sheets_client.rb  # Google Sheets API client
    ├── whmcs_client.rb          # WHMCS API client
    ├── models.rb                # Model loader
    └── models/
        ├── bank_account.rb      # FreeAgent
        ├── bill.rb              # FreeAgent
        ├── company.rb           # FreeAgent
        ├── contact.rb           # FreeAgent
        ├── expense.rb           # FreeAgent
        ├── invoice.rb           # FreeAgent
        ├── project.rb           # FreeAgent
        └── whmcs/               # WHMCS namespace
            ├── client.rb
            ├── invoice.rb
            └── transaction.rb
```

## Design Patterns

### 1. Shale Models for API Responses

All API responses should be wrapped in Shale model classes. This provides:
- Type coercion (strings to dates, floats, etc.)
- Computed properties (e.g., `display_name`, `total_value`)
- Status helpers (e.g., `paid?`, `active?`)
- ID extraction from URLs

**Pattern:**
```ruby
# models/example.rb
class Example < Shale::Mapper
  attribute :url, :string
  attribute :name, :string
  attribute :amount, :float
  attribute :status, :string

  # Extract ID from FreeAgent-style URLs
  def id
    url&.split("/")&.last
  end

  # Computed display value
  def display_amount
    "$#{"%.2f" % (amount || 0)}"
  end

  # Status helpers
  def active?
    status == "Active"
  end
end
```

**Client usage:**
```ruby
def things
  data = get("/things")["things"] || []
  parse_collection(data, Models::Thing)
end

def thing(id)
  data = get("/things/#{id}")["thing"]
  Models::Thing.from_hash(data)
end
```

### 2. Thor Command Structure

**Top-level commands** for frequently used operations:
- `sync`, `status`, `balance`, `hst`, `invoices`, `contacts`

**Subcommands** for service-specific operations:
- `auth fa`, `auth sheets`
- `sheets read`, `sheets write`, `sheets summary`
- `whmcs transactions`, `whmcs invoices`

**Aliases** for shorter typing:
- `sh` → `sheets`
- `wh` → `whmcs`
- `fa` → FreeAgent commands

**Pattern:**
```ruby
# Register subcommand
register Commands::Sheets, "sheets", "sheets SUBCOMMAND", "Description"
register Commands::Sheets, "sh", "sh SUBCOMMAND", "Alias"

# Subcommand class
module Commands
  class Sheets < Thor
    namespace :sheets

    def self.exit_on_failure?
      true
    end

    desc "read RANGE", "Read cells"
    def read(range)
      # ...
    end
  end
end
```

### 3. Configuration Management

**Two-tier storage:**
- `~/.config/syncbooks/config.json` - Cached credentials, settings
- `~/.local/share/syncbooks/credentials.json` - OAuth tokens

**1Password integration:**
- Static credentials fetched once via `setup` command
- Cached in config.json to avoid repeated prompts
- `OP_REFS` hash maps config keys to 1Password references

**Pattern:**
```ruby
OP_REFS = {
  "service_client_id" => "op://Vault/Item/field",
  "service_secret" => "op://Vault/Item/credential"
}.freeze

def self.credential(key, fallback_env: nil)
  # 1. Try config cache
  # 2. Try environment variable
  # 3. Fall back to 1Password (with warning)
end
```

### 4. UI Helpers (Gum)

All terminal output should use the `UI` module for consistency:

```ruby
UI.header("Title")           # Bordered header
UI.section("Section")        # Bold section title
UI.table(rows, columns: [])  # Formatted table
UI.success("Done!")          # Green checkmark
UI.error("Failed")           # Red X
UI.warning("Caution")        # Yellow warning
UI.muted("Subtle text")      # Faint text
UI.info("Key", "value")      # Key: value pair
UI.money(123.45)             # Formatted currency
UI.blank                     # Empty line
UI.divider                   # Horizontal line
```

**Color scheme:**
- Primary: `#7D56F4` (purple)
- Success: `#28a745` (green)
- Error: `#dc3545` (red)
- Warning: `#ffc107` (yellow)

### 5. API Client Pattern

Each external service has a dedicated client class:

```ruby
class ServiceClient
  def initialize
    load_config!
    validate_config!
  end

  def things(filter: nil)
    data = get("/things", filter: filter)
    parse_collection(data, Models::Thing)
  end

  private

  def load_config!
    @token = Config.credential("service_token")
  end

  def parse_collection(data, model_class)
    return [] if data.nil? || data.empty?
    data.map { |item| model_class.from_hash(item) }
  end

  def get(endpoint)
    # HTTP request with auth headers
    # Handle token refresh if needed
  end
end
```

### 6. Command Output Conventions

**Table output** (default):
```ruby
UI.header("Things")
UI.blank
rows = things.map { |t| [t.id, t.name, t.status] }
UI.table(rows, columns: ["ID", "Name", "Status"])
UI.blank
UI.muted("#{things.length} things")
```

**JSON output** (with `--json` flag):
```ruby
if options[:json]
  data = things.map { |t| { id: t.id, name: t.name } }
  puts JSON.pretty_generate(data)
  return
end
```

**Empty state:**
```ruby
if things.empty?
  UI.muted("No things found.")
  return
end
```

## Conventions

### Naming

- **Models:** Singular, PascalCase (`Invoice`, `Transaction`)
- **Client methods:** Plural for collections, singular for single items
  - `invoices(view: "open")` → returns array
  - `invoice(id)` → returns single model
- **Command options:** Lowercase with dashes (`--due-days`, `--tax-rate`)

### Error Handling

- Raise `Thor::Error` for user-facing errors
- Include helpful context in error messages
- For API errors, include troubleshooting steps when possible

```ruby
if result["result"] == "error"
  msg = result["message"]
  if msg&.include?("Invalid IP")
    raise <<~ERROR.strip
      API error: #{msg}

      Your IP needs to be whitelisted:
        1. Go to Admin → Settings → Security
        2. Add your IP to the allowlist
    ERROR
  end
end
```

### Safety Checks

- Production spreadsheet writes require `--force` flag
- Destructive operations should prompt for confirmation
- Use `--dev` flag for dev/test resources

## Testing Commands

```bash
# Quick smoke tests
scripts/syncbooks --help
scripts/syncbooks status
scripts/syncbooks wh test
scripts/syncbooks fa balance
scripts/syncbooks sh summary

# With options
scripts/syncbooks invoices --view open --json
scripts/syncbooks wh transactions --limit 5
scripts/syncbooks sh update:coh --dev
```

## Future Extraction Notes

When extracting to `~/src/syncbooks`:

1. **Models** - Copy directly, already standalone Shale classes
2. **Clients** - Extract HTTP/auth logic to separate modules
3. **Commands** - Map Thor commands to Crystal/Athena Console
4. **Config** - Adapt to Crystal's config patterns
5. **UI** - Replace Gum with Crystal equivalent (Sea framework?)

**Key differences for Crystal CLI:**
- Compiled binary vs Ruby script
- Athena Console instead of Thor
- Crystal HTTP client instead of HTTParty
- JSON::Serializable instead of Shale

## Adding New Features

### New API Endpoint

1. Add model in `models/` if returning structured data
2. Add client method returning model instance(s)
3. Add Thor command with table + JSON output
4. Update SKILL.md with command reference
5. Test with `--json` and default output

### New Service Integration

1. Create `lib/service_client.rb`
2. Create `lib/models/service/` namespace
3. Create `lib/commands/service.rb` subcommand
4. Add credentials to `Config::OP_REFS`
5. Register subcommand + alias in main CLI
6. Update SKILL.md and this file

## Dependencies

```ruby
gem "thor"      # CLI framework
gem "httparty"  # HTTP client
gem "webrick"   # OAuth callback server
gem "shale"     # JSON mapping/models
gem "gum"       # Terminal UI styling
```
