# Bootstrapping a New Ruby CLI Gem

Complete scaffolding for creating a new Ruby CLI tool from scratch.

## Directory Structure

```
gem-name/
├── bin/
│   └── gem-name           # Executable (distributed + development)
├── lib/
│   ├── gem_name.rb        # Root module + Zeitwerk setup
│   └── gem_name/
│       ├── version.rb     # VERSION constant
│       ├── error.rb       # Error classes
│       ├── cli.rb         # CLI module + CLI-specific errors
│       └── cli/
│           ├── base.rb    # Thor base class
│           └── main.rb    # Main CLI commands
├── gem-name.gemspec
├── Gemfile
└── .gitignore
```

## Core Files

### Executable (`bin/gem-name`)

```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true

Thread.report_on_exception = false

$LOAD_PATH.unshift File.expand_path("../lib", __dir__) unless $LOAD_PATH.include?(File.expand_path("../lib", __dir__))

require "gem_name"

begin
  GemName::Cli::Main.start(ARGV)
rescue GemName::Error => e
  warn "  \e[31mERROR (#{e.class}): #{e.message}\e[0m"
  warn e.backtrace.join("\n") if ENV["VERBOSE"]
  exit 1
rescue => e
  warn "  \e[31mERROR (#{e.class}): #{e.message}\e[0m"
  warn e.backtrace.join("\n") if ENV["VERBOSE"]
  exit 1
end
```

### Root Module (`lib/gem_name.rb`)

```ruby
# frozen_string_literal: true

module GemName
  class Error < StandardError; end
  class ConfigurationError < Error; end
end

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.ignore(File.join(__dir__, "gem_name", "error.rb"))
loader.setup
loader.eager_load_namespace(GemName::Cli)

require_relative "gem_name/error"
```

### Version (`lib/gem_name/version.rb`)

```ruby
# frozen_string_literal: true

module GemName
  VERSION = "0.1.0"
end
```

### Errors (`lib/gem_name/error.rb`)

```ruby
# frozen_string_literal: true

module GemName
  # Base Error defined in lib/gem_name.rb
  # Add additional error classes here as needed
end
```

### CLI Module (`lib/gem_name/cli.rb`)

```ruby
# frozen_string_literal: true

require "thor"

module GemName::Cli
  class CommandError < GemName::Error; end
end
```

### CLI Base (`lib/gem_name/cli/base.rb`)

```ruby
# frozen_string_literal: true

require "thor"

class GemName::Cli::Base < Thor
  def self.exit_on_failure? = true

  class_option :verbose, type: :boolean, aliases: "-v", desc: "Detailed logging"
  class_option :quiet, type: :boolean, aliases: "-q", desc: "Minimal logging"

  private

  def verbose? = options[:verbose]
  def quiet? = options[:quiet]
end
```

### Main CLI (`lib/gem_name/cli/main.rb`)

```ruby
# frozen_string_literal: true

class GemName::Cli::Main < GemName::Cli::Base
  desc "version", "Show version"
  def version
    puts GemName::VERSION
  end
end
```

### Gemspec (`gem-name.gemspec`)

```ruby
# frozen_string_literal: true

require_relative "lib/gem_name/version"

Gem::Specification.new do |spec|
  spec.name = "gem-name"
  spec.version = GemName::VERSION
  spec.authors = ["Author Name"]
  spec.email = ["author@example.com"]

  spec.summary = "Short description"
  spec.description = "Longer description of what the gem does."
  spec.homepage = "https://github.com/org/gem-name"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    Dir["{bin,lib}/**/*", "README.md"].reject { |f| File.directory?(f) }
  end

  spec.bindir = "bin"
  spec.executables = ["gem-name"]
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.3"
  spec.add_dependency "zeitwerk", ">= 2.6", "< 3.0"
end
```

### Gemfile

```ruby
# frozen_string_literal: true

source "https://rubygems.org"

gemspec
```

### Gitignore (`.gitignore`)

```gitignore
/.bundle/
/vendor/bundle
*.gem
/pkg/
/coverage/
.DS_Store
*.log
.byebug_history
```

## After Scaffolding

1. Replace `gem-name` with your gem name (hyphenated)
2. Replace `gem_name` with your gem name (underscored)
3. Replace `GemName` with your module name (PascalCase)
4. Run `bundle install`
5. Run `chmod +x bin/gem-name`
6. Test with `bin/gem-name version`
