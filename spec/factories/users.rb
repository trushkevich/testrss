require 'faker'
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.login { Faker::Internet.user_name }
    f.email { Faker::Internet.email }
    f.password { Faker::Lorem.word }
    f.profile_type { 'basic' }
    avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'rails.png'), 'image/png') }
  end

  factory :invalid_user, parent: :user do |f|
    f.first_name nil
  end

  factory :basic_user, parent: :user do |f|
    f.profile_type { 'basic' }
  end

  factory :medium_user, parent: :user do |f|
    f.profile_type { 'medium' }
  end

  factory :premium_user, parent: :user do |f|
    f.profile_type { 'premium' }
  end

  factory :twitter_user_without_email, parent: :user do |f|
    f.email { '' }
    f.provider { 'twitter' }
  end

end
