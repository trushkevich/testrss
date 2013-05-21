require 'spec_helper'

describe User do
  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end

  it "is invalid without an email" do
    FactoryGirl.build(:user, email: nil).should_not be_valid
  end

  it "is invalid without a login" do
    FactoryGirl.build(:user, login: nil).should_not be_valid
  end

  it "is invalid without a firstname" do
    FactoryGirl.build(:user, first_name: nil).should_not be_valid
  end

  it "is invalid without a lastname" do
    FactoryGirl.build(:user, last_name: nil).should_not be_valid
  end

  it "returns an user's full name as a string" do
    FactoryGirl.build(:user, first_name: "John", last_name: "Doe").full_name.should == "John Doe"
  end

  it "is invalid with a firstname more than 50 characters long" do
    FactoryGirl.build(:user, first_name: 'a'*51).should_not be_valid
  end

  it "is invalid with a lastname more than 50 characters long" do
    FactoryGirl.build(:user, last_name: 'a'*51).should_not be_valid
  end

  it "is invalid with a login more than 50 characters long" do
    FactoryGirl.build(:user, login: 'a'*51).should_not be_valid
  end

end