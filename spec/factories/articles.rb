# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title "MyString"
    link "MyString"
    description "MyText"
    published_at "2013-05-31 01:59:12"
    channel_id 1
  end
end
