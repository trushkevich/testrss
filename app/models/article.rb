require 'feedzirra'

class Article < ActiveRecord::Base
  STATUS_CREATED = 'created'

  attr_accessible :channel_id, :description, :link, :published_at, :title

  belongs_to :channel
  has_many :favourites, :as => :favouritable
  has_many :users, :through => :favourites

  validates :channel_id, presence: true 
  validates :link, presence: true 
  validates :title, presence: true 

  acts_as_commentable


  def self.create_by_channel(channel)
    # no exception handling as we assume that if channel is saved then it has a valid xml
    feed = Feedzirra::Feed.parse(channel.xml).sanitize_entries!
    fetched_articles = []
    feed.entries.each do |entry|
      article = create_by_entry(channel, entry)
      fetched_articles << article if article
    end
    {status: STATUS_CREATED, articles: fetched_articles}
  end


  def self.create_by_entry(channel, entry)
    article = Article.new(
      channel_id: channel.id,
      description: entry.summary,
      link: entry.url,
      published_at: entry.published,
      title: entry.title,
    )
    article.save ? article : nil
  end

end
