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
  end

  factory :invalid_user, parent: :user do |f|
    f.first_name nil
  end

  factory :medium_user, parent: :user do |f|
    f.profile_type { 'medium' }
  end

  factory :premium_user, parent: :user do |f|
    f.profile_type { 'premium' }
  end
end
