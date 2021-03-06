require 'feedzirra'

class Channel < ActiveRecord::Base
  include ActiveModel::Validations

  STATUS_SUBSCRIBED = 'subscribed'
  STATUS_EXISTS = 'exists'
  STATUS_SEARCHED = 'searched'
  PER_SEARCH_PAGE = 5

  attr_accessible :url, :name, :xml

  has_many :subscriptions
  has_many :users, through: :subscriptions
  has_many :articles

  validates :url, feed: true, uniqueness: true

  after_destroy :cleanup


  def subscription_name(user)
    if user and subscription = Subscription.by_user_channel_ids(user.id, id) and !subscription.name.blank?
      subscription.name
    else
      name
    end
  end


  def recent(limit)
    articles.order('published_at DESC').limit(limit)
  end


  def self.subscribe_or_find(user, search)
    channel = where(url: search).first
    if user and channel and !user.channels.include?(channel) and !user.max_channels_reached?
      user.channels << channel
      {status: STATUS_SUBSCRIBED, articles: channel.articles.limit(5), channel: channel}
    elsif user and channel and user.channels.include?(channel)
      {status: STATUS_EXISTS, articles: channel.articles.limit(5), channel: channel}
    else
      {status: STATUS_SEARCHED, channels: find_by_url_or_name(search)}
    end
  end


  def self.find_by_url_or_name(search)
    return [] if search.blank?
    channels_table = arel_table

    search_parts = search.split(' ')
    first_part = search_parts.shift

    search_by_part = ->(search) do
      channels_table[:url].matches("%#{first_part}%").or(
        channels_table[:name].matches("%#{first_part}%")
      )
    end

    where_query = search_by_part.call(first_part)
    search_parts.each do |search_part|
      where_query = where_query.and(search_by_part.call(search_part))
    end

    where(where_query).all
  end


  # to be run as a rake task
  def self.update_feeds
    puts "\nFeeds update started at #{Time.now}"
    all.each do |channel|
      feed = Feedzirra::Feed.parse(channel.xml)
      # way to DRY up the code a bit and to validate if a new feed is valid at the same time
      # here runs FeedValidator#validate_each
      if channel.update_attributes(url: channel.url)
        new_feed = Feedzirra::Feed.parse(channel.xml)
        feed.update_from_feed(new_feed)
        if feed.new_entries.count > 0
          puts "#{Time.now} > Channel id=#{channel.id}: #{feed.new_entries.count} new article(s)"
          feed.new_entries.each_with_index do |entry, i|
            if Article.create_by_entry(channel, entry)
              puts "#{Time.now} > article ##{i} successfully created"
            else
              puts "#{Time.now} ERROR > failed to create article ##{i}\n#{entry.inspect}"
            end
          end
        else
          puts "#{Time.now} > Channel id=#{channel.id}: no new articles"
        end
      else
        puts "#{Time.now} ERROR > Channel id=#{channel.id}: update failed due to feed validaion."
      end
    end
    puts "Feeds update finished at #{Time.now}\n"
  end

  # to be run as a rake task
  def self.notify_users
    puts "\nRecent feeds distribution started at #{Time.now}"
    ChannelMailer.recent_feeds_email.deliver
    puts "\nRecent feeds finished at #{Time.now}"
  end


  private

  def cleanup
    if self.is_fired?
      self.subscriptions.destroy_all
      self.articles.destroy_all
    end
  end

end
