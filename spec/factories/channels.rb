# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :channel do |f|
    f.url { "http://www.arms-tass.su/rss.xml" }
  end
end
