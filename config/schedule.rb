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

set :environment, :production
set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}
 
every '0 12 * * 2-6' do
  runner "Tasks::Get_Fx_Rate.execute"
end

every '5 12 * * 2-6' do
  runner "Tasks::Calculate_Term_Range.execute"
end

every '5 12 * * 2-6' do
  runner "Tasks::Calculate_Term_Return.execute"
end

every '10 12 * * 2-6' do
  runner "Tasks::Calculate_Term_Risk.execute"
end

every '10 12 * * 2-6' do
  runner "Tasks::Calculate_Term_Avg.execute"
end
