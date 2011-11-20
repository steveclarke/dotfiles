HOME_DIR = File.expand_path('~')
DOT_DIR  = File.join(HOME_DIR, 'src/dotfiles')

def dot(name)
  File.join(DOT_DIR, name)
end

def home(name)
  File.join(HOME_DIR, name)
end

DIRS = [{name: 'Dotfiles',     source: DOT_DIR,  target: home('.dotfiles')},
        {name: 'Bash Profile', source: dot('bash/bash_profile'), target: home('.bash_profile')}]


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
  DIRS.each do |dir|
    puts "Name: #{dir[:name]}"
    puts "Src: #{dir[:source]}"
    puts "Tgt: #{dir[:target]}"
    puts "--------------------"
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

