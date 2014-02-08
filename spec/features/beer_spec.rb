require 'spec_helper'
include OwnTestHelper

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }

  it "is saved when name is correct" do
    visit new_beer_path
    fill_in('beer[name]', with:'Iso 3')
    select('Lager', from:'beer[style]')
    select('Koff', from:'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
    expect(Brewery.first.beers.count).to eq(1)
  end

  it "is not saved when name is incorrect" do
    visit new_beer_path
    select('Lager', from:'beer[style]')
    select('Koff', from:'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to_not change{Beer.count}.from(0).to(1)
    expect(Brewery.first.beers.count).to eq(0)
    expect(page).to have_content "Name can't be blank"
    expect(current_path).to eq(beers_path)
  end
end