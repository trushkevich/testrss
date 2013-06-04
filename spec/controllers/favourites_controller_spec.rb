require 'spec_helper'

describe FavouritesController do

  describe "GET 'add_to_favourites'" do
    it "returns http success" do
      get 'add_to_favourites'
      response.should be_success
    end
  end

  describe "GET 'remove_from_favourites'" do
    it "returns http success" do
      get 'remove_from_favourites'
      response.should be_success
    end
  end

end
