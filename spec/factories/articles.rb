# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :article do |f|
    f.title { "MyString" }
    f.link { "http://google.com" }
    f.description { "MyText" }
    f.published_at { (Time.now + rand(100)) }
    f.channel_id { 1 }
  end

end
