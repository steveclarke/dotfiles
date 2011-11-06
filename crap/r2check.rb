## Checks pre-Rails 2.0 apps for compatibility (v1.0)
# Usage - download and run while in your application root directory:
#
#   ruby r2check.rb
#
# Alternative - run straight from Pastie:
#
#   wget http://pastie.caboo.se/99900.txt?key=krcevozww61drdeza13e3a -q -O- | ruby -
#     (or:)
#   curl http://pastie.caboo.se/99900.txt?key=krcevozww61drdeza13e3a -s | ruby -
#
# 
# NOTE: this script does simple, regular expression searches. It might *not* be right at all times.
# Consider this script just for informative purposes.
# 
# Author: Mislav Marohnić

require 'yaml'

specs = YAML::load <<YML
breakpoint server:
  pattern: '\\bbreakpoint_server\\b'
  where: config
  info: 'The configuration option has been removed in favor of the better ruby-debug library.'
  gem: ruby-debug
  solution: 'Remove the line(s) from configuration since the setting has no effect anymore.  Instead, start `script/server` with the "-u" or "--debugger" option (or "-h" to see all the options).'
  changeset: 6627

with_scope:
  pattern: '[A-Z]\\w+\\.with_scope\\b'
  info: 'This class method has been declared private to model classes.'
  solution: "Don't use it directly.  You can only use it internally from the model class itself."
  changeset: 6909

singular resources:
  pattern: "\\\\.resource\\\\s+[:\\"'](\\w+)"
  eval: "File.exist?('app/controllers/' + $1 + '_controller.rb') and line !~ /:controller\\\\b/"
  where: routes
  info: "Singular resources map to pluralized controllers now (ie. map_resource(:post) maps to PostsController)."
  solution: "Rename your singular controller(s) to plural or use the :controller option in `map.resource` to override the controller name it maps to."
  changeset: 6922

pagination:
  pattern: '[^.\\w](paginate|(?:find|count)_collection_for_pagination|pagination_links(?:_each)?)\\b'
  where: controllers, views
  changeset: 6992
  info: "Pagination has been extracted from Rails core."
  solution: "Alternative: you can replace your pagination calls with will_paginate (find it on http://rock.errtheblog.com/)."
  plugin: svn://errtheblog.com/svn/plugins/classic_pagination

push_with_attributes:
  pattern: '\\.push_with_attributes\\b'
  info: This method on associations has been removed from Rails.
  solution: "If you need attributes on associations, use has_many :through."
  changeset: 6997

find_first or find_all:
  pattern: '\\b(find_first|[A-Z]\\w+\\.find_all)\\b'
  where: models, controllers
  info: "AR::Base `find_first` and `find_all` class methods have been removed.  (If you're in fact using `find_all` method of Enumerable, ignore this warning.)"
  solution: "Use `find(:first)` or `find(:all)`."
  changeset: 6998

Hash.create_from_xml:
  pattern: '\\bHash.create_from_xml\\b'
  info: "`Hash.create_from_xml` has been renamed to `from_xml`."
  changeset: 7085

nested resource named routes:
  pattern: '\\b\\w+_(new|edit)_\\w+_(url|path)\\b'
  where: controllers, views
  info: "Nested resource named routes are now prefixed by their action name."
  solution: "Rename your calls to such named routes from ie. 'group_new_user_path' to 'new_group_user_path'.  Same applies for 'edit' paths."
  changeset: 7138

belongs_to foreign key assumption:
  pattern: '\\bbelongs_to\\b.+:class_name\\b'
  eval: 'line !~ /:foreign_key\\b/'
  where: models
  info: "The foreign key name is no longer inferred from the explicit class name, but from the association name."
  solution: "Make sure the foreign key for your association is in the form of '{association_name}_id'.  (See the changeset for an example)."
  changeset: 7188

old association dependencies:
  pattern: ':dependent\\s*=>\\s*true|:exclusively_dependent\\b'
  where: models
  info: "Specifying dependencies in associations has a new form and the old API has been removed."
  solution: "Change ':dependent => true' to ':dependent => :destroy' and ':exclusively_dependent' to ':dependent => :delete_all'."
  changeset: 7402

old render methods:
  pattern: '\\brender_(action|with(out)?_layout|file|text|template)\\b'
  where: controllers
  info: "The old `render_{something}` API has been removed."
  solution: "Change `render_action` to `render :action`, `render_text` to `render :text` (and so on) in your controllers."
  changeset: 7403

template root:
  pattern: '\\btemplate_root\\b'
  info: "`template_root` has been dropped in favor of `view_paths` array."
  solution: 'Replace `template_root = "some/dir"` with `view_paths = "some/dir"`.'
  changeset: 7426

expire matched fragments:
  pattern: '\\bexpire_matched_fragments\\b'
  where: controllers
  info: "`expire_matched_fragments` has been superseded by `expire_fragment`."
  solution: "Simply call `expire_fragment` with a regular expression."
  changeset: 7427

expire matched fragments:
  pattern: '\\bkeep_flash\\b'
  where: controllers
  info: "`keep flash` has been superseded by `flash.keep`."
  changeset: 7428

dynamic scaffold:
  pattern: '\\bscaffold\\b'
  where: controllers
  plugin: scaffolding
  info: "Dynamic scaffolding has gone the way of the dinosaurs."
  solution: "Don't use it.  Use the 'scaffold' generator to generate scaffolding for RESTful resources."
  changeset: 7429

image tag without extension:
  pattern: "\\\\bimage_tag\\s*(\\(\\s*)?('[^'.]+'|\\"[^\\".]+\\")"
  where: views
  info: ".png is no longer the default extension for images."
  solution: "Explicitly set the image extension when using `image_tag`: instead of just `image_tag 'logo'`, use 'logo.png'."
  changeset: 7432

cookie:
  pattern: ^\\s*cookie\\b
  where: controllers
  info: "The `cookie` writer method was removed from controllers."
  solution: "Use `cookies[name] = value` instead."
  changeset: 7434

javascript in-place editor:
  pattern: \\b(in_place_editor_field|in_place_edit_for)\\b
  where: views, controllers
  plugin: in_place_editing
  info: "The in-place editor has been extracted from Rails core."
  changeset: 7442

javascript autocompleter:
  pattern: \\b(auto_complete_field|auto_complete_for)\\b
  where: views, controllers
  plugin: auto_complete
  info: "The autocompleter has been extracted from Rails core."
  changeset: 7450

acts_as_list:
  pattern: \\bacts_as_list\\b
  where: models
  plugin: acts_as_list
  info: "acts_as_list has been extracted from Rails core."
  changeset: 7444

acts_as_nested_set:
  pattern: \\bacts_as_nested_set\\b
  where: models
  plugin: acts_as_nested_set
  info: "acts_as_nested_set has been extracted from Rails core."
  changeset: 7453

acts_as_tree:
  pattern: \\bacts_as_tree\\b
  where: models
  plugin: acts_as_tree
  info: "acts_as_tree has been extracted from Rails core."
  changeset: 7454

reloadable:
  pattern: \\binclude\\s+Reloadable\\b
  info: "Reloadable module is removed from Rails."
  solution: "Don't include the module anymore. Dependencies code is smart enough to reload classes if they're not in 'load_once' paths."
  changeset: 7473
YML

for props in specs.values
  next unless props['pattern']
  props['pattern'] = Regexp.new props['pattern']
  props['found'] = []
end

class String
  def word_wrap(line_width = 78)
    self.split("\n").collect do |line|
      line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line
    end * "\n"
  end

  def camelize
    self.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end
end

files = (Dir["{app,config,db/migrate,lib,test}/**/*.rb"] + Dir['app/views/**/*.{rhtml,rxml,erb,builder,haml}']).sort
files -= ['config/boot.rb']

plugins = Dir['vendor/plugins/*'].map{ |p| File.basename p }.sort

files.each do |filename|
  File.open(filename).each_with_index do |line, ln|
    next if line =~ /^\s*#/ # skip commented lines
    for props in specs.values
      if props['where']
        where = props['where'].scan /\w+/
        next unless where.any? do |place|
            case place
            when 'controllers', 'models'
              filename.index("app/#{place}/") == 0
            when 'views'
              filename =~ %r[^app/(views|helpers)/]
            when 'routes'
              filename == 'config/routes.rb'
            else
              filename.index("#{place}/") == 0
            end
          end
      end
      
      if line =~ props['pattern'] and (props['eval'].nil? or eval(props['eval']))
        props['found'] << "#{filename}:#{ln + 1}:  #{line.strip}"
      end
    end
  end
end

found = false

for name, props in specs
  unless props['found'].empty?
    plugin = (props['plugin'] and File.basename(props['plugin']))
    next if plugin and (plugins.include?(plugin) or (plugin == 'classic_pagination' and plugins.include? 'will_paginate'))

    unless found
      puts(("Your application doesn't seem ready to upgrade to Rails 2.0." +
        " Please take a moment to review the following:").word_wrap(80))
    end
    found = true
    title = "-- #{name} "
    puts "\n" + title.ljust(80, '-')

    text = []

    text << (props['info'] + "  (changeset #{props['changeset']})").word_wrap
    
    if props['gem']
      text << ''
      text << "  gem install #{props['gem']}"
    end
    if props['plugin']
      text << ''
      text << "  script/plugin install #{props['plugin']}"
    end
    
    if props['solution']
      text << ''
      text << props['solution'].word_wrap
    end

    text << ''
    text << "files:"
    text << props['found'].join("\n")

    puts "\n  " + text.join("\n").gsub("\n", "\n  ")
  end
end

unless found
  puts "Congratulations! Your application seems ready for Rails 2.0"
end