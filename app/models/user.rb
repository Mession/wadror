class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3 }, length: { maximum: 15 }
  validates :password, length: { minimum: 4 }, format: /\A(?=.*\d)(?=.*[A-Z]).{4,}\z/

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    calculate_favorite_style
  end

  def calculate_favorite_style
    styles = ["Weizen", "Lager", "Pale ale", "IPA", "Porter"]
    favorite = nil
    score = -1
    styles.each do |style|
      rats = ratings.find_all { |r| r.beer.style == style }.map{ |ra| ra.score}
      average = rats.sum.to_f / rats.count.to_f unless rats.nil?
      if rats.nil?
      elsif average > score
        favorite = style
        score = average
      end
    end
    favorite
  end

  def favorite_brewery
    return nil if ratings.empty?
    calculate_favorite_brewery
  end

  def calculate_favorite_brewery
    breweries = ratings.map{ |r| r.beer.brewery }
    favorite = nil
    score = -1
    breweries.each do |brewery|
      rats = ratings.find_all { |r| r.beer.brewery == brewery }.map{ |ra| ra.score}
      average = rats.sum.to_f / rats.count.to_f unless rats.nil?
      if rats.nil?
      elsif average > score
        favorite = brewery
        score = average
      end
    end
    favorite
  end
end
