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
  runner "Tasks::Calculate_Term_Return.execute"
end

every '10 12 * * 2-6' do
  runner "Tasks::Calculate_Term_Risk.execute"
  runner "Tasks::Calculate_Term_Avg.calc_range_avg"
  runner "Tasks::Calculate_Term_Avg.calc_rate_avg"
end

every '10 12 * * 2-6' do
  runner "Tasks::Calculate_Daily_Pivot.execute"
  runner "Tasks::Calculate_Bolinger_Band.execute"
  runner "Tasks::Calculate_Rsi.execute"
  runner "Tasks::Calculate_Stochastics.execute"
  runner "Tasks::Calculate_Difference_From_Ma.execute"
end

=begin
every '0 18 * * 1-5' do
  runner "Tasks::Get_Market_Data.execute('IX','AS')"
end

every '0 2 * * 2-6' do
  runner "Tasks::Get_Market_Data.execute('IX','EU')"
end

every '0 7 * * 2-6' do
  runner "Tasks::Get_Market_Data.execute('IX','AM')"
  runner "Tasks::Get_Market_Data.execute('BD','AM')"
end
=end

every 4.minute do
  runner "Tasks::Check_Alert_Rate.check_alert_setting('FX','DMY')"
end
