# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "cron.log"
#set :output, {:standard => 'cron.log'}
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
every 1.day do
  runner "Project.send_email_to_buyer"
end

# every 5.hours do
#   runner "User.automatic_withdrawal"
# end


every 1.day do
    runner "UserMembershipPlan.automatic_membership_renewal"
end


# Learn more: http://github.com/javan/whenever
