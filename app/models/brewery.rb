class Brewery < ActiveRecord::Base
  include RatingAverage

  validates :year, numericality: { greater_than_or_equal_to: 1042, only_integer: true }
  validate :year_not_in_future
  validates :name, presence: true

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def year_not_in_future
    if year.present? && year > Date.today.year
      errors.add(:year, "cannot be in the future!")
    end
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
    puts "number of ratings #{ratings.count}"
  end

  def restart
    self.year = 2014
    puts "changed year to #{year}"
  end
end