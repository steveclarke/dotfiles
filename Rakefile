require 'json'

# -------------------------------------------------------------------------
#                            Task Dependencies                            |
# -------------------------------------------------------------------------

task 'default'                => [ 'install' ]
task 'install'                => [ 'core:install',   'vim:install' ]
task 'uninstall'              => [ 'core:uninstall', 'vim:uninstall' ]
task 'core:install'           => [ :init, :check ]
task 'core:uninstall'         => [ :init ]
task 'vim:install'            => [ :init, :check ]
task 'vim:uninstall'          => [ :init ]
task 'vim:bundles:install'    => [ :init, :check ]
task 'vim:bundles:uninstall'  => [ :init ]
task 'vim:bundles:update'     => [ :init ]
task 'vim:bundles:config'     => [ :init ]
task 'git:config'             => [ :init, :check ]
task 'osx:config'             => [ :init, :check ]
task 'zsh:config'             => [ :init, :check ]

# -------------------------------------------------------------------------
#                               Initialize                                |
# -------------------------------------------------------------------------

task :init do
  HOME_DIR         = File.expand_path('~')
  DOT_DIR          = File.join(HOME_DIR, 'src/dotfiles')
  VIM_BUNDLES_DIR  = File.join(HOME_DIR, 'src/vim_bundles')

  CORE_DIRS = {
    dotfiles:     { source: DOT_DIR,                  target: home('.dotfiles') },
    bash_profile: { source: dot('bash/bash_profile'), target: home('.bash_profile') },
    zshrc:        { source: dot('zsh/zshrc'),         target: home('.zshrc') },
    bin:          { source: dot('bin'),               target: home('bin') },
    gemrc:        { source: dot('ruby/gemrc'),        target: home('.gemrc') },
  }

  VIM_DIRS = {
    dotvim: { source: dot('vim/vim'),    target: home('.vim') },
    vimrc:  { source: dot('vim/vimrc'),  target: home('.vimrc') },
    gvimrc: { source: dot('vim/gvimrc'), target: home('.gvimrc') },
  }
end

# -------------------------------------------------------------------------
#                              Sanity Check                               |
# -------------------------------------------------------------------------

task :check do
  if File.directory?(DOT_DIR)
    puts ">>> We have a ~/src/dotfiles directory... good."
  else
    puts "I'm expecting stuff to be setup inside ~/src/dotfiles."
    puts "Just what do you think you're doing, Dave....er I mean Steve."
    exit
  end
end

# -------------------------------------------------------------------------
#                           Install Everything                            |
# -------------------------------------------------------------------------
desc 'Install core + Vim'
task :install do
  # only follow dependencies defined above
end

# -------------------------------------------------------------------------
#                          Uninstall Everything                           |
# -------------------------------------------------------------------------
desc 'Uninstall core + Vim'
task :uninstall do
  # only follow dependencies defined above
end

# -------------------------------------------------------------------------
#                              Install Core                               |
# -------------------------------------------------------------------------

namespace :core do
  desc 'Install core'
  task :install do
    CORE_DIRS.each do |name, dirs|
      puts "### #{name.upcase}"
      create_symlink(dirs[:source], dirs[:target])
    end
  end
end

# -------------------------------------------------------------------------
#                             Uninstall Core                              |
# -------------------------------------------------------------------------

namespace :core do
  desc 'Uninstall core symlinks'
  task :uninstall do
    puts "### Uninstalling..."
    CORE_DIRS.each do |name, dirs|
      rm(dirs[:target]) if File.exists?(dirs[:target])
    end
    puts 'Finished uninstalling.'
  end
end

# -------------------------------------------------------------------------
#                               Install Vim                               |
# -------------------------------------------------------------------------

namespace :vim do
  desc 'Install Vim'
  task :install do
    # symlinks
    VIM_DIRS.each do |name, dirs|
      puts "### #{name.upcase}"
      create_symlink(dirs[:source], dirs[:target])
    end
  end
end

# -------------------------------------------------------------------------
#                              Uninstall Vim                              |
# -------------------------------------------------------------------------

namespace :vim do
  desc 'Uninstall Vim'
  task :uninstall do
    # symlinks
    VIM_DIRS.each do |name, dirs|
      rm(dirs[:target])
    end
  end
end

# -------------------------------------------------------------------------
#                           Install Vim Bundles                           |
# -------------------------------------------------------------------------

namespace 'vim:bundles' do
  desc 'Install Vim bundles'
  task :install do
    # vim bundles (for Pathogen)
    if File.directory?(VIM_BUNDLES_DIR)
      puts "*** Skipping #{VIM_BUNDLES_DIR}. Already exists."
    else
      puts "+++ Creating #{VIM_BUNDLES_DIR}"
      mkdir_p(VIM_BUNDLES_DIR)
    end
    # clone bundles
    bundle_sources.each do |name, source|
      clone_to = File.join(VIM_BUNDLES_DIR, name)
      if File.directory?(clone_to)
        puts "*** Skipping #{name}. Already exists."
      else
        puts "+++ Cloning #{name}..."
        sh "git clone #{source} #{clone_to}"
      end
    end
  end
end

# -------------------------------------------------------------------------
#                          Uninstall Vim Bundles                          |
# -------------------------------------------------------------------------

namespace 'vim:bundles' do
  desc 'Uninstall Vim bundles'
  task :uninstall do
    rm_rf(VIM_BUNDLES_DIR) if File.directory?(VIM_BUNDLES_DIR)
  end
end

# -------------------------------------------------------------------------
#                           Update Vim Bundles                            |
# -------------------------------------------------------------------------

namespace 'vim:bundles' do
  desc 'Update Vim bundles'
  task :update do
    if !File.directory?(VIM_BUNDLES_DIR)
      puts "Oops! You should install bundles first with 'rake vim:bundles:install'"
      exit
    end
    bundle_sources.each do |name, source|
      clone_to = File.join(VIM_BUNDLES_DIR, name)
      puts "+++ Updating #{name}..."
      cd clone_to
      sh "git pull"
    end
  end
end

# -------------------------------------------------------------------------
#                           Config Vim Bundles                            |
# -------------------------------------------------------------------------
namespace 'vim:bundles' do
  desc 'Config Vim bundles'
  task :config do
    if !File.directory?(VIM_BUNDLES_DIR)
      puts "Oops! You should install bundles first with 'rake vim:bundles:install'"
      exit
    end
    # TODO: compile Command-T extensions
  end
end

# -------------------------------------------------------------------------
#                                 Helpers                                 |
# -------------------------------------------------------------------------

def create_symlink(source, target)
  if File.directory?(target) || File.exists?(target)
    puts "*** Skipping #{target}. Already exists."
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

def bundle_sources
  bundles_file = File.open(File.join(DOT_DIR, 'vim/bundles.json'), 'r').read
  JSON.parse(bundles_file)
end
