# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# Create log directory if it doesn't exist
job_type :rake, 'cd :path && mkdir -p log && :environment_variable=:environment bundle exec rake :task :output'

set :output, "log/cron_log.log"

# Update attractions every two weeks at midnight
every 2.weeks, at: '00:00' do
  rake "attractions:update"
end
