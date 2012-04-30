source 'http://rubygems.org'

gem 'rails', '3.1.1'
gem 'rake', '0.9.2'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'
group :development do
  gem 'mysql2', "0.3.7"
end

group :production do
  gem 'pg'
end
gem 'kaminari'
gem 'thin'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails', "1.0.19"
gem "rspec-rails", ">= 2.8.0.rc1", :group => [:development, :test]
gem "devise", "1.5.3"
gem 'web-app-theme', '~> 0.8.0'
gem 'faker'
gem "acts_as_audited", "2.0.0"
gem "cancan"
gem "rolify"
gem 'newrelic_rpm'
#gem 'rails_admin', :git => "http://github.com/sferik/rails_admin.git"
#gem 'minitest', :group => :test
gem 'tinymce-rails'

group :test do
  gem "database_cleaner", ">= 0.7.0"
  gem 'rails3-generators'
  gem "factory_girl_rails", ">= 1.4.0"
  gem "cucumber-rails", ">= 1.2.0", require: false
  gem "capybara", ">= 1.1.2"
  gem 'spork', '0.9.0.rc9'
  gem "launchy", ">= 2.0.5"
end
