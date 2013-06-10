namespace :cron do

  namespace :channels do
    task :update => :environment do
      Channel.update_feeds
    end

    task :notify_users => :environment do
      Channel.notify_users
    end
  end

end