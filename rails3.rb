# remove files
run "rm README"
run "rm public/index.html"
run "rm public/images/rails.png"
run "cp config/database.yml config/database.yml.example"

# install gems
gem 'yajl-ruby', :require => 'yajl'
gem 'nokogiri'

gem 'mysql2'
gem "kaminari"

gem "rspec", "~> 2.0", :group => [:test, :development]
gem "rspec-rails", "~> 2.0", :group => [:test, :development]
gem "factory_girl_rails", :group => [:test, :development]
gem "shoulda-matchers", :group => [:test, :development]
gem "rcov", :group => [:test, :development]
gem "delorean", :group => [:test, :development]
gem "watchr", :group => [:test, :development]

# generate rspec
generate "rspec:install"

# copy files
file 'script/watchr.rb', File.read("#{File.dirname(rails_template)}/watchr.rb")
file 'lib/tasks/dev.rake', File.read("#{File.dirname(rails_template)}/dev.rake")

# remove active_resource and test_unit
gsub_file 'config/application.rb', /require 'rails\/all'/, <<-CODE
  require 'rails'
  require 'active_record/railtie'
  require 'action_controller/railtie'
  require 'action_mailer/railtie'
CODE

# install jquery
run "curl -L http://code.jquery.com/jquery.min.js > public/javascripts/jquery.js"
run "curl -L http://github.com/rails/jquery-ujs/raw/master/src/rails.js > public/javascripts/rails.js"

gsub_file 'config/application.rb', /(config.action_view.javascript_expansions.*)/, 
                                   "config.action_view.javascript_expansions[:defaults] = %w(jquery rails)"

# add time format
environment 'Time::DATE_FORMATS.merge!(:default => "%Y/%m/%d %I:%M %p", :ymd => "%Y/%m/%d")'

# .gitignore
append_file '.gitignore', <<-CODE
config/database.yml
Thumbs.db
.DS_Store
tmp/*
coverage/*
CODE

# keep tmp and log
run "touch tmp/.gitkeep"
run "touch log/.gitkeep"

# git commit
git :init
git :add => '.'
git :add => 'tmp/.gitkeep -f'
git :add => 'log/.gitkeep -f'
git :commit => "-a -m 'initial commit'"