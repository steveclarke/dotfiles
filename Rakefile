HOME_DIR = File.expand_path('~')
DOT_DIR  = File.join(HOME_DIR, 'src/dotfiles')

def dot(name)
  File.join(DOT_DIR, name)
end

def home(name)
  File.join(HOME_DIR, name)
end

DIRS = {
  dotfiles:     { source: DOT_DIR,                  target: home('.dotfiles') },
  bash_profile: { source: dot('bash/bash_profile'), target: home('.bash_profile') },
  zshrc:        { source: dot('zsh/zshrc'),         target: home('.zshrc') },
  bin:          { source: dot('bin'),               target: home('bin') },
  gemrc:        { source: dot('ruby/gemrc'),        target: home('.gemrc') },
  vim:          { source: dot('vim/vim'),           target: home('.vim') },
  vimrc:        { source: dot('vim/vimrc'),         target: home('.vimrc') },
  gvimrc:       { source: dot('vim/gvimrc'),        target: home('.gvimrc') },
}

# -------------------------------------------------------------------------
#                                Uninstall                                |
# -------------------------------------------------------------------------

desc 'uninstall the symlinks'
task :uninstall do
  dirs = [File.join(HOME_DIR, '.dotfiles'),
          File.join(HOME_DIR, '.bash_profile'),
          File.join(HOME_DIR, '.zshrc'),
          File.join(HOME_DIR, 'bin'),
          File.join(HOME_DIR, '.gemrc'),
          File.join(HOME_DIR, '.vim'),
          File.join(HOME_DIR, '.vimrc'),
          File.join(HOME_DIR, '.gvimrc'),
  ]

  dirs.each do |dir|
    rm(dir) if File.exists?(dir)
  end

  puts 'Finished uninstalling.'
end


# -------------------------------------------------------------------------
#                                 Install                                 |
# -------------------------------------------------------------------------

desc 'Install everything'
task :install do
  DIRS.each do |name, dirs|
    puts "--- #{name.upcase}"
    create_symlink(dirs[:source], dirs[:target])
  end
end


# -------------------------------------------------------------------------
#                                 Helpers                                 |
# -------------------------------------------------------------------------

def create_symlink(source, target)
  if File.directory?(target) || File.exists?(target)
    puts "### Skipping #{target}. Already exists."
  else
    puts "+++ Creating #{target}"
    ln_s(source, target)
  end
end

