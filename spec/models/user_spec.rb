require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if password is too short" do
    user = User.create username:"Pekka", password:"Pk1", password_confirmation:"Pk1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if password contains only characters" do
    user = User.create username:"Pekka", password:"PekkA", password_confirmation:"PekkA"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating = FactoryGirl.create(:rating)
      rating2 = FactoryGirl.create(:rating2)

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest ratings" do
      style = FactoryGirl.create(:style)
      lager = create_beer(25, user, style)
      style = FactoryGirl.create(:style2)
      weizen = create_beer(15, user, style)

      expect(user.favorite_style).to eq(lager.style)
    end

    it "is not the highest rated, but the one with highest average rating" do
      style = FactoryGirl.create(:style)
      lager = create_beer(10, user, style)
      style = FactoryGirl.create(:style2)
      weizen = create_beer(11, user, style)
      weizen2 = create_beer(5, user, style)

      expect(user.favorite_style).to eq(lager.style)
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one with highest ratings" do
      worst = create_brewery(10, user)
      best = create_brewery(15, user)

      expect(user.favorite_brewery).to eq(best)
    end

    it "is not the highest rated, but the one with highest average rating" do
      best = create_brewery(10, user)
      bad = create_brewery(11, user)
      beer = FactoryGirl.create(:beer, brewery:bad)
      beer.ratings << FactoryGirl.create(:rating, score:5, beer:beer, user:user)

      expect(user.favorite_brewery).to eq(best)
    end
  end
end

def create_brewery(score, user)
  brewery = FactoryGirl.create(:brewery)
  beer = FactoryGirl.create(:beer, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  brewery
end

def create_beer(score, user, style)
  beer = FactoryGirl.create(:beer, style:style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating score, user
  end
end

def create_beer_with_rating(score,  user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score,  beer:beer, user:user)
  beer
end