require 'resque'
require 'resque/failure/multiple'
require 'resque/failure/redis'
require 'resque/rollbar'

Resque.redis = ENV['REDIS_URL']

# Resque.logger.formatter = Resque::VeryVerboseFormatter.new
Resque.logger.level = Logger::DEBUG
Resque::Failure::Multiple.classes = [ Resque::Failure::Redis, Resque::Failure::Rollbar ]
Resque::Failure.backend = Resque::Failure::Multiple

Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds
