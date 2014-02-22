class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3 }, length: { maximum: 15 }
  validates :password, length: { minimum: 4 }, format: /\A(?=.*\d)(?=.*[A-Z]).{4,}\z/

  has_many :ratings, dependent: :destroy
  has_many :beers, -> { uniq }, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  # omat vanhat favorite style & favorite brewery

  #def favorite_style
  #  return nil if ratings.empty?
  #  calculate_favorite_style
  #end
  #
  #def calculate_favorite_style
  #  styles = ["Weizen", "Lager", "Pale ale", "IPA", "Porter"]
  #  favorite = nil
  #  score = -1
  #  styles.each do |style|
  #    rats = ratings.find_all { |r| r.beer.style == style }.map{ |ra| ra.score}
  #    average = rats.sum.to_f / rats.count.to_f unless rats.nil?
  #    if rats.nil?
  #    elsif average > score
  #      favorite = style
  #      score = average
  #    end
  #  end
  #  favorite
  #end
  #
  #def favorite_brewery
  #  return nil if ratings.empty?
  #  calculate_favorite_brewery
  #end
  #
  #def calculate_favorite_brewery
  #  breweries = ratings.map{ |r| r.beer.brewery }
  #  favorite = nil
  #  score = -1
  #  breweries.each do |brewery|
  #    rats = ratings.find_all { |r| r.beer.brewery == brewery }.map{ |ra| ra.score}
  #    average = rats.sum.to_f / rats.count.to_f unless rats.nil?
  #    if rats.nil?
  #    elsif average > score
  #      favorite = brewery
  #      score = average
  #    end
  #  end
  #  favorite
  #end

  # omat vanhat end

  def favorite_brewery
    return nil if ratings.empty?
    brewery_ratings = rated_breweries.inject([]) { |set, brewery| set << [brewery, brewery_average(brewery) ] }
    brewery_ratings.sort_by{ |r| r.last }.last.first
  end

  def favorite_style
    return nil if ratings.empty?
    style_ratings = rated_styles.inject([]) { |set, style| set << [style, style_average(style) ] }
    style_ratings.sort_by{ |r| r.last }.last.first
  end

  private

  def rated_styles
    ratings.map{ |r| r.beer.style }.uniq
  end

  def style_average(style)
    ratings_of_style = ratings.select{ |r| r.beer.style==style }
    ratings_of_style.inject(0.0){ |sum, r| sum+r.score}/ratings_of_style.count
  end

  def rated_breweries
    ratings.map{ |r| r.beer.brewery}.uniq
  end

  def brewery_average(brewery)
    ratings_of_brewery = ratings.select{ |r| r.beer.brewery==brewery }
    ratings_of_brewery.inject(0.0){ |sum, r| sum+r.score}/ratings_of_brewery.count
  end
end
