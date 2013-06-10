
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

log = Dir.pwd+'/log/cron.log'
File.open(log,'a') {|log|}
set :output, log

every 5.minutes do
  rake "cron:channels:update"
end

every 1.day, :at => '3:00 am' do
  rake "cron:channels:notify_users"
end
