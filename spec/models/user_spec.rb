require 'spec_helper'

describe User do
  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end

  it "is invalid with a firstname more than 50 characters long" do
    FactoryGirl.build(:user, first_name: 'a'*51).should_not be_valid
  end

  it "is invalid without a firstname" do
    FactoryGirl.build(:user, first_name: nil).should_not be_valid
  end

  it "is invalid with a lastname more than 50 characters long" do
    FactoryGirl.build(:user, last_name: 'a'*51).should_not be_valid
  end

  it "is invalid without a lastname" do
    FactoryGirl.build(:user, last_name: nil).should_not be_valid
  end

  it "is invalid with a login more than 50 characters long" do
    FactoryGirl.build(:user, login: 'a'*51).should_not be_valid
  end

  it "is invalid without a login" do
    FactoryGirl.build(:user, login: nil).should_not be_valid
  end

  it "is invalid with an occupied login" do
    FactoryGirl.create(:user, login: 'john111').should be_valid
    FactoryGirl.build(:user, login: 'john111').should_not be_valid
  end

  it "is invalid without an email if there is no provider" do
    FactoryGirl.build(:user, email: '', provider: nil).should_not be_valid
  end

  it "is valid without an email if there a provider" do
    FactoryGirl.build(:user, email: '', provider: 'twitter').should be_valid
  end

  it "returns an user's full name as a string" do
    FactoryGirl.build(:user, first_name: "John", last_name: "Doe").full_name.should == "John Doe"
  end

  it "is invalid without a profile_type" do
    FactoryGirl.build(:user, profile_type: nil).should_not be_valid
  end

  it "is invalid with a wrong profile_type" do
    FactoryGirl.build(:user, profile_type: 'wrong').should_not be_valid
  end

  it "should have a maximum number of subscribed channels set to 10 with a basic profile type" do
    FactoryGirl.build(:basic_user).max_channels.should == 10
  end

  it "should have a maximum number of subscribed channels set to 20 with a medium profile type" do
    FactoryGirl.build(:medium_user).max_channels.should == 20
  end

  it "should have a maximum number of subscribed channels set to 100 with a premium profile type" do
    FactoryGirl.build(:premium_user).max_channels.should == 100
  end

  it "should tell that a maximum allowed number of channels is reached when a number of subscribed channels reaches its maximum" do
    user = FactoryGirl.create(:basic_user)
    channel = FactoryGirl.create(:channel)
    10.times { user.channels << channel }
    user.max_channels_reached?.should be_true
  end

  it "should tell that a maximum allowed number of channels is not reached when a number of subscribed channels hasn't reached its maximum"  do
    user = FactoryGirl.create(:basic_user)
    channel = FactoryGirl.create(:channel)
    9.times { user.channels << channel }
    user.max_channels_reached?.should be_false
  end

  it "should be able to scope to users with email" do
    regular_user = FactoryGirl.create(:user, first_name: 'John')
    twitter_user = FactoryGirl.build(:twitter_user_without_email, first_name: 'Jack')
    twitter_user.confirm!
    twitter_user.save!
    User.with_email.count.should == 1 and User.with_email.first.first_name.should == regular_user.first_name
  end

  it "should tell to Devise that email is required for regular user" do
    regular_user = FactoryGirl.create(:user)
    regular_user.email_required?.should be_true
  end

  it "should tell to Devise that email is not required for oauth user" do
    twitter_user = FactoryGirl.build(:twitter_user_without_email)
    twitter_user.email_required?.should be_false
  end

  it "should tell to Devise that password is required for regular user" do
    regular_user = FactoryGirl.create(:user)
    regular_user.password_required?.should be_true
  end

  it "should tell to Devise that password is not required for oauth user" do
    twitter_user = FactoryGirl.build(:twitter_user_without_email)
    twitter_user.password_required?.should be_false
  end

end