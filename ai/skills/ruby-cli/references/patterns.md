# Command Patterns & Thor Reference

Patterns for adding commands and working with Thor.

## Adding a Command

```ruby
class GemName::Cli::Main < GemName::Cli::Base
  desc "deploy", "Deploy application"
  option :env, type: :string, default: "production", desc: "Target environment"
  option :force, type: :boolean, aliases: "-f", desc: "Skip confirmation"
  def deploy
    # implementation
  end
end
```

## Adding a Subcommand

Create the subcommand class:

```ruby
# lib/gem_name/cli/deploy.rb
class GemName::Cli::Deploy < GemName::Cli::Base
  desc "setup", "Initial setup"
  def setup
    # implementation
  end

  desc "push", "Push to servers"
  def push
    # implementation
  end
end
```

Register in Main:

```ruby
desc "deploy", "Deployment commands"
subcommand "deploy", GemName::Cli::Deploy
```

## Thor Options

```ruby
# Types: :string, :boolean, :numeric, :array, :hash
option :env, type: :string, default: "production"
option :force, type: :boolean, aliases: "-f"
option :tags, type: :array, desc: "Multiple values"
option :config, type: :hash, desc: "Key=value pairs"

# Class options (inherited by subcommands)
class_option :config_file, aliases: "-c", default: "config.yml"
```

## Thor Output

```ruby
say "Success!", :green
say "Warning!", :yellow
say "Error!", :red
say "Info", :blue
say "Note", :magenta
```

## Thor Input

```ruby
answer = ask("Continue?", limited_to: %w[y n], default: "n")
name = ask("Project name:")
password = ask("Password:", echo: false)
```

## Invoking Other Commands

```ruby
def setup
  invoke "gem_name:cli:build:prepare", [], options
  invoke "gem_name:cli:deploy:push", [], options
end
```

## Long Description

```ruby
desc "deploy", "Deploy application"
long_desc <<~DESC
  Deploy the application to the specified environment.

  Examples:
    $ gem-name deploy --env staging
DESC
def deploy
  # ...
end
```
