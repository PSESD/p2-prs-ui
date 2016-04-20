source 'https://rubygems.org'
ruby '2.2.4'

gem 'rails', '4.2.6'
gem 'dotenv-rails', :groups => [:development, :test]
gem 'brakeman', require: false, :groups => [:development, :test]
gem 'sass-rails' #, '~> 5.0'
gem 'uglifier' #, '>= 1.3.0'
gem 'coffee-rails' #, '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder' #, '~> 2.0'
gem 'sdoc' #,'~> 0.4.0', group: :doc
gem 'bootstrap-sass'
gem 'simple_form'
gem 'active_rest_client'
gem 'nprogress-rails'
gem 'coderay', :require =>  'coderay'
gem 'rollbar'
gem 'resque'
gem 'resque-rollbar'
gem 'resque-status'
gem 'bundler-audit'
gem 'mongoid'
gem 'bcrypt'

group :development, :test do
  gem 'dotenv'
  gem 'byebug'
  gem 'web-console' #, '~> 2.0'
  gem 'spring'
  gem 'awesome_print'
  
  gem 'pronto'
  gem 'pronto-rubocop', require: false
  gem 'pronto-brakeman', require: false
  gem 'pronto-flay', require: false
  gem 'pronto-rails_best_practices', require: false
end

group :production do
  gem 'rack-wwwhisper' #, '~> 1.0'
  gem 'rails_12factor'
  gem 'puma'
end
