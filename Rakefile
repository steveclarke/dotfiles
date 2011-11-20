# -------------------------------------------------------------------------
#                            Task Dependencies                            |
# -------------------------------------------------------------------------

task :default   => [ :install ]
task :install   => [ :init, :setup ]
task :uninstall => [ :init ]

# -------------------------------------------------------------------------
#                               Initialize                                |
# -------------------------------------------------------------------------

desc 'Initialize setup directories'
task :init do
  HOME_DIR = File.expand_path('~')
  DOT_DIR  = File.join(HOME_DIR, 'src/dotfiles')

  CORE_DIRS = {
    dotfiles:     { source: DOT_DIR,                  target: home('.dotfiles') },
    bash_profile: { source: dot('bash/bash_profile'), target: home('.bash_profile') },
    zshrc:        { source: dot('zsh/zshrc'),         target: home('.zshrc') },
    bin:          { source: dot('bin'),               target: home('bin') },
    gemrc:        { source: dot('ruby/gemrc'),        target: home('.gemrc') },
    vim:          { source: dot('vim/vim'),           target: home('.vim') },
    vimrc:        { source: dot('vim/vimrc'),         target: home('.vimrc') },
    gvimrc:       { source: dot('vim/gvimrc'),        target: home('.gvimrc') },
  }
end

# -------------------------------------------------------------------------
#                                  Setup                                  |
# -------------------------------------------------------------------------

desc 'Perform sanity check and core setup'
task :setup do
  if File.directory?(DOT_DIR)
    puts "--> Looks like we have a ~/src/dotfiles directory... moving right along...\n\n"
  else
    puts "I'm expecting stuff to be setup inside ~/src/dotfiles."
    puts "Just what do you think you're doing, Dave....er I mean Steve."
    exit
  end
end

# -------------------------------------------------------------------------
#                                 Install                                 |
# -------------------------------------------------------------------------

desc 'Install everything'
task :install do
  CORE_DIRS.each do |name, dirs|
    puts "--- #{name.upcase}"
    create_symlink(dirs[:source], dirs[:target])
  end
end

# -------------------------------------------------------------------------
#                                Uninstall                                |
# -------------------------------------------------------------------------

desc 'uninstall the symlinks'
task :uninstall do
  puts "--- Uninstalling..."
  CORE_DIRS.each do |name, dirs|
    rm(dirs[:target]) if File.exists?(dirs[:target])
  end
  puts 'Finished uninstalling.'
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

def dot(name)
  File.join(DOT_DIR, name)
end

def home(name)
  File.join(HOME_DIR, name)
end
