class Beer < ActiveRecord::Base
  include RatingAverage

  validates :name, presence: true

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  def to_s
    "#{name} by #{brewery.name}"
  end

  #def average_rating
  #  @ratings = Rating.where(beer_id: id)
  #  @ratings.collect(&:score).inject { |sum, n| sum + n }.to_f / @ratings.size
  #end

  #def old_average_rating
  #  #@ratings = Rating.find_all_by_beer_id(id)
  #  @ratings = Rating.where(beer_id: id)
  #  @sum = 0
  #  @ratings.each do |rating|
  #    @sum += rating.score
  #  end
  #  @sum /= @ratings.size
  #end
end