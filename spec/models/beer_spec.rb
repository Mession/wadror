require 'spec_helper'

describe Beer do
  it "is saved when name and style are set correctly" do
    beer = Beer.create name:"Testiolut", style:"Testi"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    beer = Beer.create style:"Testi"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name:"Testiolut"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
