require 'spec_helper'
include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "can be seen on the Ratings-page" do
    r1 = FactoryGirl.create(:rating, user:user, beer:beer1)
    r2 = FactoryGirl.create(:rating2, user:user, beer:beer2)
    visit ratings_path

    expect(page).to have_content "Number of ratings: #{Rating.count}"
    expect(page).to have_content "#{r1.beer.name} #{r1.score} Pekka"
    expect(page).to have_content "#{r2.beer.name} #{r2.score} Pekka"
  end

  it "can be seen on the page of the user who created the rating" do
    u2 = FactoryGirl.create(:user, username:"Pena")
    r1 = FactoryGirl.create(:rating, user:user, beer:beer1)
    r2 = FactoryGirl.create(:rating2, user:u2, beer:beer1)
    visit user_path(user)

    expect(page).to have_content "#{r1.beer.name} #{r1.score}"
    expect(page).not_to have_content "#{r2.beer.name} #{r2.score}"
  end

  it "is removed from database when the user who created the rating deletes it" do
    r1 = FactoryGirl.create(:rating, user:user, beer:beer1)
    visit user_path(user)

    expect{
      click_link "delete"
    }.to change{Rating.count}.from(1).to(0)
  end
end