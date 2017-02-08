require 'resque/tasks'

namespace :resque do
  task :setup do
    require 'resque'
    ENV['QUEUE'] = '*'

    # Resque.redis = Rails.application.secrets.redis_url
    # Resque.redis = 'localhost:6379' if Rails.env == 'local'
  end
end

Resque.after_fork = Proc.new { ActiveRestClient::Base.establish_connection } #this is necessary for production environments, otherwise your background jobs will start to fail when hit from many different connections.

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"
