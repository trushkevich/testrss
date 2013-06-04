class Channel < ActiveRecord::Base
  include ActiveModel::Validations

  STATUS_SUBSCRIBED = 'subscribed'
  STATUS_EXISTS = 'exists'
  STATUS_CREATED = 'created'
  STATUS_SEARCHED = 'searched'

  attr_accessible :url, :name, :xml

  has_many :subscriptions
  has_many :users, through: :subscriptions
  has_many :articles

  validates :url, feed: true, uniqueness: true


  def subscription_name(user)
    if user and subscription = Subscription.by_user_channel_ids(user.id, id) and !subscription.name.blank?
      subscription.name
    else
      name
    end
  end


  def create_articles
    # no exception handling as we assume that if channel is saved then it has a valid xml
    feed = Feedzirra::Feed.parse(xml).sanitize_entries!
    fetched_articles = []
    feed.entries.each do |entry|
      article = Article.new(
        channel_id: id,
        description: entry.summary,
        link: entry.url,
        published_at: entry.published,
        title: entry.title,
      )
     fetched_articles << article if article.save
    end
    {status: STATUS_CREATED, articles: fetched_articles}
  end


  def self.subscribe_or_find(user, search)
    channel = where(url: search).first
    if channel and !user.channels.include? channel and !user.max_channels_reached?
      user.channels << channel
      {status: STATUS_SUBSCRIBED, articles: channel.articles}
    elsif channel and user.channels.include? channel
      {status: STATUS_EXISTS, articles: channel.articles}
    else
      {status: STATUS_SEARCHED, channels: find_by_url_or_name(search)}
    end
  end


  def self.find_by_url_or_name(search)
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


end
