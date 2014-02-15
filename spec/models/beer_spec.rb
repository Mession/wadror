require 'spec_helper'

describe Beer do
  it "is saved when name and style are set correctly" do
    style = FactoryGirl.create(:style)
    beer = Beer.create name:"Testiolut", style:style

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    style = FactoryGirl.create(:style)
    beer = Beer.create style:style

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name:"Testiolut"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
