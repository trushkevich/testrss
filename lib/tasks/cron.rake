namespace :cron do

  namespace :channels do
    task :update => :environment do
      Channel.update_feeds
    end
  end

end